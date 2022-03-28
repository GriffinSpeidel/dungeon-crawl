extends Popup

signal end_battle
signal game_over
signal win
var current
var next
var TurnManager
var party
var encounter
var encounter_res
var order = []
var order_i
var MessageTimer
var live_party_members = []

var enemy_res = [preload("res://EnemyHead.tscn")]
var box_res = load("res://EnemyBox.tscn")

func _initialize(party):
	self.party = party
	encounter = $EncounterNode.get_children()
	update_player_health()
	choose_order()
	order_i = 0
	take_turn()
	for c in party:
		if c.hp > 0:
			live_party_members.append(c)

func choose_order():
	encounter = $EncounterNode.get_children()
	order = []
	var i = 0
	for e in encounter:
		order.append([e, e.stats[1] * Global.rand.randf_range(0.7, 1.3)])
	for c in party:
		if c.hp > 0:
			order.append([i, c.stats[1] * Global.rand.randf_range(0.7, 1.3)])
		i += 1
	order.sort_custom(self, "sort_creatures")
	display_order()

func display_order():
	var order_label = "Round Order: "
	var i = 0
	for x in order:
		if typeof(x[0]) == TYPE_INT:
			order_label += '(' + str(i) + ') ' + party[x[0]].c_name + '   '
		else:
			order_label += '(' + str(i) + ') ' + x[0].c_name + ' ' + str(x[0].id) + '   '
		i += 1
		$OrderLabel.text = order_label

func remove_from_order(creature):
	for i in range(len(order)):
		print(str(order[i][0]) + str(creature))
		if typeof(order[i][0]) != TYPE_INT and order[i][0] == creature:
			order.remove(i)
			display_order()
			break

func sort_creatures(a, b):
	return a[1] >= b[1]

func take_turn():
	if typeof(order[order_i][0]) == TYPE_INT:
		current = order[order_i][0]
		var manager_res = 	load("res://TurnManager.tscn")
		TurnManager = manager_res.instance()
		add_child(TurnManager)
		TurnManager.get_node("BattleMenu").rect_position = Vector2(100 + 300 * current, 350)
		TurnManager.connect("end_battle", self, "_on_end_battle")
		TurnManager.connect("update_boxes", self, "_on_TurnManager_update_boxes")
		TurnManager.connect("win", self, "_on_TurnManager_win")
		
	else:
		live_party_members = []
		for c in party:
			if c.hp > 0:
				live_party_members.append(c)
		if len(live_party_members) == 0:
			game_over()
		elif is_instance_valid(order[order_i][0]):
			add_message(order[order_i][0].act(live_party_members))
			update_player_health()
			MessageTimer = Timer.new()
			MessageTimer.autostart = true
			add_child(MessageTimer)
			MessageTimer.wait_time = 0.75
			MessageTimer.connect("timeout", self, "_on_MessageTimer_timeout")

func game_over():
	emit_signal("game_over")

func _on_MessageTimer_timeout():
	MessageTimer.queue_free()
	advance_turn()

func advance_turn():
	if order_i < len(order) - 1:
		order_i += 1
		take_turn()
		
	else:
		choose_order()
		order_i = 0
		take_turn()

func turn_end(message):
	add_message(message)
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

func fill_and_draw(res):
	encounter_res = res
	for i in range(len(encounter_res)):
		$EncounterNode.add_child(enemy_res[encounter_res[i]].instance())
		$EncounterNode.get_child(i)._initialize(1, i + 1) # level
		var box = box_res.instance()
		$EncounterNode.get_child(i).add_child(box)
		update_enemy_health_box(i)
		$EncounterNode.get_child(i).get_child(0).rect_position = Vector2(412 - 110 * (len(encounter_res) - 1) + i * 220, 100)

func _on_TurnManager_update_boxes():
	encounter = $EncounterNode.get_children()
	var l = len(encounter)
	for i in range(l):
		$EncounterNode.get_child(i).get_child(0).rect_position = Vector2(412 - 110 * (l - 1) + i * 220, 100)

func update_enemy_health_box(i):
	var box_i = $EncounterNode.get_child(i).get_child(0)
	box_i.get_child(1).text = $EncounterNode.get_child(i).c_name + ' ' + str($EncounterNode.get_child(i).id) + ' lvl.' + str($EncounterNode.get_child(i).level)
	box_i.get_child(2).rect_size.x = float($EncounterNode.get_child(i).hp) / $EncounterNode.get_child(i).hp_max * 172

func _on_TurnManager_win():
	emit_signal("win", TurnManager.get_index())

func add_message(message):
	$BattleMessage.add_message(message)
