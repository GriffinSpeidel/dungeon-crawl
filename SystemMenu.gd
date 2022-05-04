extends Control

signal close_sys
signal save_game
signal load_game
var TextTimer

func _on_Close_pressed():
	emit_signal("close_sys")

func _on_Save_pressed():
	$ColorRect/ReferenceRect/Save.text = "Game Saved!"
	TextTimer = Timer.new()
	TextTimer.autostart = true
	TextTimer.wait_time = 1
	TextTimer.connect("timeout", self, "_on_TextTimer_timeout")
	add_child(TextTimer)
	$ColorRect/ReferenceRect/Save.disabled = true
	$ColorRect/ReferenceRect/Save.mouse_default_cursor_shape = 0
	emit_signal("save_game")

func _on_TextTimer_timeout():
	$ColorRect/ReferenceRect/Save.disabled = false
	$ColorRect/ReferenceRect/Save.mouse_default_cursor_shape = 2
	$ColorRect/ReferenceRect/Save.text = "Save Game"
	TextTimer.queue_free()

func _on_Quit_pressed():
	get_tree().quit()

func _on_Load_pressed():
	emit_signal("load_game")
