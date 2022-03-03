extends Popup

signal end_battle
var current

func take_turn(current, next):
	self.current = current
	var manager_res = load("res://TurnManager.tscn")
	var manager = manager_res.instance()
	add_child(manager)
	manager.get_node("BattleMenu").rect_position = Vector2(100 + 300 * current, 350)
	manager.connect("end_battle", self, "_on_end_battle")

func _on_end_battle():
	emit_signal("end_battle")

func update_enemy_health(encounter, i):
	var box_i = encounter[i].get_child(0)
	box_i.get_child(1).text = encounter[i].type
	box_i.get_child(2).rect_size.x = float(encounter[i].hp) / encounter[i].hp_max * 172
	#box_i.get_child(2).text = "HP: " + str(int(float(encounter[i].hp) / encounter[i].hp_max * 100)) + "%"
	#box_i.get_child(2).text = "HP: " + str(encounter[i].hp) + "/" + str(encounter[i].hp_max)
