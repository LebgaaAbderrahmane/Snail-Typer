extends CanvasLayer

func _on_play_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/gameplayScene.tscn")
	

func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
