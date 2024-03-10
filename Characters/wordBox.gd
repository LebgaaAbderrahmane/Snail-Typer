extends Area2D

@export var red = Color("#fe0000")
@export var grey = Color("718ba2")
@export var white = Color("#ffffff")
@export var speed: float = 0.8
@export var MAX_SPEED: float = 10.0
@onready var prompt = $RichTextLabel
@onready var prompt_text = prompt.text
@onready var prompt_next_char_index = 0
@onready var river_index: int = -1

func _physics_process(delta):
	if speed > MAX_SPEED: 
		speed = MAX_SPEED
	global_position.x -= speed
	
func set_next_char_index(i: int): 
	prompt_next_char_index = i

func get_next_char_index() -> int: 
	return prompt_next_char_index
	
func set_prompt(word:String): 
	$RichTextLabel.set_text(word)
	prompt_text = $RichTextLabel.text
	
func get_prompt() -> String: 
	return prompt_text
	
func set_river_index(i: int): 
	river_index = i
	
func get_river_index() -> int: 
	return river_index
	
func get_speed() -> float: 
	return speed
	
func set_speed(plier: float): 
	speed += plier * 0.12

func set_next_char_color(next_char_index: int): 
	var grey_text = get_bbcode_color_tag(grey) + prompt_text.substr(0, next_char_index) + get_bbcode_end_color_tag()
	var red_text = get_bbcode_color_tag(red) + prompt_text.substr(next_char_index, 1) + get_bbcode_end_color_tag()
	var white_text = get_bbcode_color_tag(white) + prompt_text.substr(next_char_index + 1, prompt_text.length()) + get_bbcode_end_color_tag()
	prompt.parse_bbcode(grey_text + "[u]" + red_text + "[/u]" + white_text)
	
func get_bbcode_color_tag(color:Color) -> String: 
	return "[color=#" + color.to_html(false) + "]"
	
func get_bbcode_end_color_tag()	-> String: 
	return "[/color]"

