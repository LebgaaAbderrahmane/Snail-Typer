extends Node2D

var titleOpen = false

@onready var music = $titleBGM
@onready var ambience = $ambienceBGM
@onready var titleLogo = $logoSprite
@onready var titleBox = preload("res://Scenes/title_box.tscn")
@onready var enterText = $enterText
@onready var flashTimer = $flashTimer

func _ready():
	ambience.play()
	flashTimer.start()
	set_process_unhandled_input(true)
	titleOpen = false

func _input(event): 
	if event.is_action_pressed("ui_accept"): 
		if titleOpen == false: 
			titleLogo.hide()
			enterText.hide()
			titleOpen = true 
			var box = titleBox.instantiate()
			add_child(box)
			ambience.stop()
			music.play()

func _on_flash_timer_timeout():
	if titleOpen == false:
		enterText.visible = not enterText.visible
