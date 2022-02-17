extends Node

signal end_battle
func take_turn(current, next):
	var manager_res = load("res://BattleManager.tscn")
	var manager = manager_res.instance()
	add_child(manager)
	manager.get_node("BattleMenu").rect_position = Vector2(100 + 300 * current, 350)
	manager.connect("end_battle", self, "_on_end_battle")

func _on_end_battle():
	emit_signal("end_battle")
