extends Control

signal close

func add_message(message):
	$EndBattleMessage.add_message(message)


func _on_Next_pressed():
	emit_signal("close")
