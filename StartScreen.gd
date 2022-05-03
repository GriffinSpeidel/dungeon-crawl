extends Control

func _on_Button_pressed():
	get_tree().change_scene("res://Main.tscn")

func _process(delta):
	if Input.is_action_just_pressed("toggle_fulscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
