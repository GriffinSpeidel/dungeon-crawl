extends Popup

signal end_battle
signal game_over
var current
var next
var TurnManager
var EndBattleMenu
var party
var encounter
var encounter_res
var order = []
var order_i
var MessageTimer
var live_party_members = []
var xp_pool
var ap_pool
var item_level
var max_encounter_len

var enemy_res = [preload("res://EnemyHead.tscn")]
var box_res = load("res://EnemyBox.tscn")

func _initialize(party):
	xp_pool = 0
	ap_pool = 0
	item_level = 0
	self.party = party
	encounter = $EncounterNode.get_children()
	max_encounter_len = len(encounter)
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
		if is_instance_valid(e) and e.hp > 0:
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
			order_label += '(' + str(i + 1) + ') ' + party[x[0]].c_name + '   '
		else:
			order_label += '(' + str(i + 1) + ') ' + x[0].c_name + ' ' + str(x[0].id) + '   '
		i += 1
		$OrderLabel.text = order_label

func remove_from_order(creature):
	for i in range(len(order)):
		if typeof(order[i][0]) == typeof(creature) and order[i][0] == creature:
			order.remove(i)
			display_order()
			break

func sort_creatures(a, b):
	return a[1] >= b[1]

func take_turn():
	# turnmanager setup
	if typeof(order[order_i][0]) == TYPE_INT:
		current = order[order_i][0]
		party[current].guarding = false
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
		else:
			advance_turn()

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

func _on_end_battle(): # once flee code works this shouldnt be necessary anymore
	TurnManager.queue_free()
	emit_signal("end_battle")

func update_player_health():
	var party_boxes = $Control.get_children()
	for i in range(3):
		party[i].hp = 0 if party[i].hp < 0 else party[i].hp
		if party[i].hp == 0:
			remove_from_order(i)
		party_boxes[i].get_child(1).get_child(1).text = "HP: " + str(party[i].hp) + "/" + str(party[i].hp_max)
		party_boxes[i].get_child(1).get_child(2).text = "MP: " + str(party[i].mp) + "/" + str(party[i].mp_max)

func fill_and_draw(res, levels): # 0: Head 1: Suit 2: Plant 3: Ooze
	encounter_res = res
	for i in range(len(encounter_res)):
		$EncounterNode.add_child(enemy_res[encounter_res[i]].instance())
		$EncounterNode.get_child(i)._initialize(levels[i], i + 1) # level, index
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
	if TurnManager != null:
		TurnManager.queue_free()
	var end_menu_res = load("res://EndBattleMenu.tscn")
	EndBattleMenu = end_menu_res.instance()
	EndBattleMenu.connect("close", self, "_on_EndBattleMenu_close")
	EndBattleMenu.rect_position = Vector2(100, 100)
	EndBattleMenu.get_node("Next").disabled = true
	
	var skill_messages = []
	for c in party:
		if c.hp > 0:
			c.experience += xp_pool
			if c.weapon != null:
				print('e')
				var skill_learned = c.weapon.add_ap(ap_pool, c)
				if skill_learned != null:
					skill_messages.append(c.c_name + " learned " + skill_learned.s_name + "!")
					c.learn_skill(skill_learned)
	
	add_child(EndBattleMenu)
	EndBattleMenu.add_message("Each party member gained " + str(xp_pool) + "XP.")
	EndBattleMenu.add_message("Each party member gained " + str(ap_pool) + "AP for their weapon.")
	for string in skill_messages:
		EndBattleMenu.add_message(string)
	
	if Global.rand.randf() < 1-(1/(pow(1.3,max_encounter_len))):
		var item_drop
		item_level += Global.rand.randi() % 5
		if item_level > 32:
			item_drop = Consumeable.new("Grape Bunch", 16)
		elif item_level > 16:
			item_drop = Consumeable.new("Healing Grape", 8)
		else:
			item_drop = Consumeable.new("Grapeseed", 4)
		if len(get_parent().inventory) < 24:
			get_parent().inventory.append(item_drop)
			EndBattleMenu.add_message("You got a " + item_drop.g_name + "!")
		else:
			EndBattleMenu.add_message("The enemy dropped a " + item_drop.g_name + ", but your inventory is full.")
	
	check_level_up()

func _on_EndBattleMenu_close():
	EndBattleMenu.queue_free()
	emit_signal("end_battle")

func check_level_up():
	for c in party:
		if c.experience >= 100:
			level_up_character(c)
			return true
	EndBattleMenu.get_node("Next").disabled = false
	return false
	
func level_up_character(c):
	c.level_up()
	c.connect("level_next_character", self, "check_level_up")
	
func add_message(message):
	$BattleMessage.add_message(message)
