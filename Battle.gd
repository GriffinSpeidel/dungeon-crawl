extends Popup

signal end_battle
var current
var next
var TurnManager
var party
var encounter
var order = []
var order_i

func _initialize(party, encounter):
	self.party = party
	self.encounter = encounter
	update_player_health()
	choose_order()
	order_i = 0
	take_turn()

func choose_order():
	order = []
	var i = 0
	for e in encounter:
		order.append([e, e.stats[1] * Global.rand.randf_range(0.7, 1.3)])
	for c in party:
		order.append([i, c.stats[1] * Global.rand.randf_range(0.7, 1.3)])
		i += 1
	order.sort_custom(self, "sort_creatures")
	var order_label = "Round Order: "
	i = 0
	for x in order:
		if typeof(x[0]) == TYPE_INT:
			order_label += '(' + str(i) + ') ' + party[x[0]].c_name + '   '
		else:
			order_label += '(' + str(i) + ') ' + x[0].type + '   '
		i += 1
		$OrderLabel.text = order_label

func sort_creatures(a, b):
	return a[1] >= b[1]

func take_turn():
	if typeof(order[order_i][0]) == TYPE_INT:
		current = order[order_i][0]
		if party[current].hp > 0:
			var manager_res = 	load("res://TurnManager.tscn")
			TurnManager = manager_res.instance()
			add_child(TurnManager)
			TurnManager.get_node("BattleMenu").rect_position = Vector2(100 + 300 * current, 350)
			TurnManager.connect("end_battle", self, "_on_end_battle")
		else:
			advance_turn()
	else:
		var live_party_members = []
		for c in party:
			if c.hp > 0:
				live_party_members.append(c)
		order[order_i][0].act(live_party_members)
		update_player_health()
		advance_turn()

func advance_turn():
	if order_i < len(order) - 1:
		order_i += 1
		take_turn()
		
	else:
		choose_order()
		order_i = 0
		take_turn()
	

func turn_end():
	TurnManager.queue_free()
	advance_turn()

func _on_end_battle():
	emit_signal("end_battle", TurnManager.get_index())

func update_player_health():
	var party_boxes = $Control.get_children()
	for i in range(3):
		party[i].hp = 0 if party[i].hp < 0 else party[i].hp
		party_boxes[i].get_child(1).get_child(1).text = "HP: " + str(party[i].hp) + "/" + str(party[i].hp_max)
		party_boxes[i].get_child(1).get_child(2).text = "MP: " + str(party[i].mp) + "/" + str(party[i].mp_max)

func update_enemy_health(encounter, i):
	var box_i = encounter[i].get_child(0)
	box_i.get_child(1).text = encounter[i].type
	box_i.get_child(2).rect_size.x = float(encounter[i].hp) / encounter[i].hp_max * 172
	#box_i.get_child(2).text = "HP: " + str(int(float(encounter[i].hp) / encounter[i].hp_max * 100)) + "%"
	#box_i.get_child(2).text = "HP: " + str(encounter[i].hp) + "/" + str(encounter[i].hp_max)
