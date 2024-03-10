extends CanvasLayer


func _ready(): 
	self.offset = Vector2((ProjectSettings.get_setting("display/window/size/viewport_width") / 6), (ProjectSettings.get_setting("display/window/size/viewport_height") / 10))
	$PanelContainer/MarginContainer/CenterContainer/VBoxContainer/optionsButton.hide()

func _on_play_button_pressed():
	get_tree().paused = false
	self.queue_free()
	get_tree().change_scene_to_file("res://Scenes/gameplayScene.tscn")
	


func _on_options_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
