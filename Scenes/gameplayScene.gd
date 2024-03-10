extends Node2D

signal unpaused

var active_word = null
var cur_letter_index: int = -1
var last_index: int = -1
var words_typed: int = 0
var correct_letters: int = 0
var total_letters: int = 0
var letter_percent: float = 0
var difficulty: int = 1
var begin = false

@onready var file = "res://curated_word_list.txt"
@onready var word_box = preload("res://Characters/wordBox.tscn")
@onready var game_over = preload("res://Scenes/game_over.tscn")
@onready var explosion = $fartExplosion
@onready var word_container = $wordContainer
@onready var spawn_container = $spawnContainer
@onready var spawn_timer = $spawnTimer
@onready var player_snail = $playerSnail
@onready var player_collider = $playerSnail/RayCast2D
@onready var typed_label = $CanvasLayer/typedLabel2
@onready var percent_label = $CanvasLayer/typedLabel4
@onready var wordList: Array[String] 
@onready var hit_sfx = $hitSFX
@onready var miss_sfx = $missSFX
@onready var complete_sfx = $completeSFX
@onready var fart_sfx = $fartSFX
@onready var bgm_sfx = $playingBGM
@onready var howTo = $howToBox

func _ready():
	howTo.offset = Vector2((ProjectSettings.get_setting("display/window/size/viewport_width") / 6), (ProjectSettings.get_setting("display/window/size/viewport_height") / 10))
	set_process_unhandled_input(true)
	explosion.hide()
	get_tree().paused = false
	load_file(file)
	randomize()

func _process(delta): #checks if a word is finished, updates active_word when new word is detected, and keeps up with letter_percent
	#checks if a finished word is still active, despawns it if so
	if active_word != null and cur_letter_index == active_word.get_prompt().length(): 
		unload_word()
		
	if player_collider.get_collider() != null: 
		if player_collider.get_collider().is_in_group("words"):
			active_word = player_collider.get_collider()
			cur_letter_index = active_word.get_next_char_index()
		else: 
			active_word = null
	
	if correct_letters > 0: 
		letter_percent = ((float(correct_letters)/total_letters)*100)
		percent_label.text = "%s%%" % snapped(letter_percent, 0.01)
		
	

func _unhandled_input(event: InputEvent): #input manager
	if begin == false:
		if event.is_action_pressed("ui_accept"): 
			begin = true 
			spawn_timer.start()
			spawn_enemy()
			howTo.hide()
			
	if event.is_action_pressed("move_down") or event.is_action_pressed("move_up"): 
		return
		
	if event is InputEventKey  and event.is_pressed() and not event.is_echo() and active_word != null: 
		var typed_event = event as InputEventKey
		var key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8().to_lower()
		var prompt = active_word.get_prompt()
		var next_char = prompt.substr(cur_letter_index, 1)
		total_letters += 1
		if (key_typed == next_char): #correct letter condition; sets word coloring and cur_letter_index, unloads word if needed
			cur_letter_index += 1
			active_word.set_next_char_index(cur_letter_index)
			active_word.set_next_char_color(cur_letter_index)
			correct_letters += 1
			if cur_letter_index == prompt.length(): 
				unload_word()
			else: 
				hit_sfx.play()
		else: 
			miss_sfx.play()
				
				
func _on_timer_timeout():
	spawn_enemy()

func spawn_enemy(): #determines where next letter will spawn from, runs specific_spawn at that index
	var spawns = spawn_container.get_children()
	var index = randi() % spawns.size()
	if difficulty > 5 and difficulty % 3 == 0: 
		match index: 
			0: 
				specific_spawn(1)
				specific_spawn(2)
			1: 
				specific_spawn(0)
				specific_spawn(2)
			2: 
				specific_spawn(0)
				specific_spawn(1)
	else:
		specific_spawn(index)
	
func specific_spawn(index: int): #spawn handler; sets word, speed, and starting position of spawned word
	var spawns = spawn_container.get_children()
	var word_instance = word_box.instantiate()
	word_instance.set_prompt(wordList.pick_random())
	last_index = index
	word_instance.set_speed(float(difficulty))
	word_instance.set_river_index(index)
	word_container.add_child(word_instance)
	word_instance.global_position = spawns[index].global_position
	
func unload_word(): #updates score, deletes completed word, resets active_word
	words_typed += 1
	typed_label.text = str(words_typed)
	cur_letter_index = -1
	active_word.queue_free()
	active_word = null
	complete_sfx.play()
	
	
func _on_area_2d_area_entered(area):
	area.queue_free()

func _on_difficulty_timer_timeout():
	difficulty += 1
	if spawn_timer.wait_time > 2.5:
		if difficulty > 10: 
			spawn_timer.wait_time -= 0.4
		else: 
			spawn_timer.wait_time -= 0.2
	else:
		spawn_timer.wait_time = 2.5

func _on_river_area_entered(area): #lose condition handler (word hits river mouth)
	set_process_unhandled_input(false)
	explosion.global_position = player_snail.global_position
	explosion.show()
	explosion.get_child(1).play("kaboom")
	bgm_sfx.stop()
	fart_sfx.play()
	player_snail.hide()
	await get_tree().create_timer(1.4).timeout
	get_tree().paused = true
	var over = game_over.instantiate()
	add_child(over)
	over.offset = Vector2((ProjectSettings.get_setting("display/window/size/viewport_width") / 6), (ProjectSettings.get_setting("display/window/size/viewport_height") / 10))
	
func load_file(File): #loads text file for assignment to wordBoxes
	var f = FileAccess.open(File, FileAccess.READ)
	var index = 0
	var line = ""
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		line = f.get_line()
		wordList.append(line)
		index += 1
	f.close()
	return
	
