extends Popup

signal end_battle
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
var encounter_len
var max_encounter_len
var mat_drops
var is_boss

var enemy_res = [preload("res://EnemyHead.tscn"), preload("res://EnemyOoze.tscn"), preload("res://EnemyPlant.tscn"), preload("res://EnemySuit.tscn"), preload("res://EnemyGremlin.tscn"), preload("res://EnemyKing.tscn")]
var box_res = load("res://EnemyBox.tscn")

func _initialize(party):
	xp_pool = 0
	ap_pool = 0
	item_level = 0
	mat_drops = []
	for i in range(11):
		mat_drops.append(0)
	self.party = party
	max_encounter_len = len(encounter)
	encounter_len = max_encounter_len
	update_player_health()
	choose_order()
	order_i = 0
	take_turn()
	for c in party:
		if c.hp > 0:
			live_party_members.append(c)

func choose_order():
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
	if typeof(order[order_i][0]) == TYPE_INT: # character turn
		current = order[order_i][0]
		party[current].guarding = false
		var manager_res = 	load("res://TurnManager.tscn")
		TurnManager = manager_res.instance()
		add_child(TurnManager)
		TurnManager.get_node("BattleMenu").rect_position = Vector2(100 + 300 * current, 350)
		TurnManager.connect("end_battle", self, "_on_TurnManager_end_battle")
		TurnManager.connect("update_boxes", self, "_on_TurnManager_update_boxes")
		TurnManager.connect("decrease_encounter", self, "_on_TurnManager_decrease_encounter")
		TurnManager.connect("win", self, "_on_TurnManager_win")
		
	else: # enemy turn
		live_party_members = []
		for c in party:
			if c.hp > 0:
				live_party_members.append(c)
		if len(live_party_members) == 0:
			game_over()
		elif is_instance_valid(order[order_i][0]):
			add_message(order[order_i][0].act(live_party_members))
			update_player_health()
			for c in party:
				if c.hp <= 0:
					add_message(c.c_name + " falls.")
			update_enemy_health_box()
			MessageTimer = Timer.new()
			MessageTimer.autostart = true
			add_child(MessageTimer)
			MessageTimer.wait_time = 0.75
			MessageTimer.connect("timeout", self, "_on_MessageTimer_timeout")
		else:
			advance_turn()

func game_over():
	var game_over_res = load("res://GameOver.tscn")
	var GameOver = game_over_res.instance()
	GameOver.rect_position = Vector2(287, 350)
	GameOver.name = "GameOver"
	GameOver.get_node("Return").connect("pressed", get_parent(), "_on_Battle_game_over")
	add_child(GameOver)

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

func update_player_health():
	var party_boxes = $Control.get_children()
	for i in range(3):
		party[i].hp = 0 if party[i].hp < 0 else party[i].hp
		if party[i].hp == 0:
			remove_from_order(i)
		party_boxes[i].get_child(1).get_child(1).text = "HP: " + str(party[i].hp) + "/" + str(party[i].hp_max)
		party_boxes[i].get_child(1).get_child(2).text = "MP: " + str(party[i].mp) + "/" + str(party[i].mp_max)

func fill_and_draw(res, levels, is_boss): # 0: Head 1: Ooze 2: Plant 3: Suit
	encounter = []
	self.is_boss = is_boss
	encounter_res = res
	for i in range(len(encounter_res)):
		$EncounterNode.add_child(enemy_res[encounter_res[i]].instance())
		encounter.append($EncounterNode.get_child(i))
		$EncounterNode.get_child(i)._initialize(levels[i], i + 1) # level, index
		var box = box_res.instance()
		var sprite = Sprite.new()
		sprite.texture = $EncounterNode.get_child(i).texture
		sprite.centered = false
		box.add_child(sprite)
		$EncounterNode.get_child(i).add_child(box)
		update_enemy_health_box()
		$EncounterNode.get_child(i).get_child(0).rect_position = Vector2(412 - 110 * (len(encounter_res) - 1) + i * 220, 100)

func _on_TurnManager_update_boxes():
	for i in range(len(encounter)):
		encounter[i].get_child(0).rect_position = Vector2(412 - 110 * (encounter_len - 1) + i * 220, 100)

func _on_TurnManager_decrease_encounter():
	encounter_len -= 1

func update_enemy_health_box():
	for i in range(len(encounter)):
		var box_i = $EncounterNode.get_child(i).get_child(0)
		box_i.get_child(0).text = $EncounterNode.get_child(i).c_name + ' ' + str($EncounterNode.get_child(i).id) + ' lvl.' + str($EncounterNode.get_child(i).level)
		box_i.get_child(1).rect_size.x = float($EncounterNode.get_child(i).hp) / $EncounterNode.get_child(i).hp_max * 172

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
			c.mp = min(c.mp_max, c.mp + max(1, c.mp_max / 16))
			c.experience += xp_pool
			if c.weapon != null:
				var skill_learned = c.weapon.add_ap(ap_pool, c)
				if skill_learned != null:
					skill_messages.append(c.c_name + " learned " + skill_learned.s_name + "!")
					c.learn_skill(skill_learned)
	
	add_child(EndBattleMenu)
	EndBattleMenu.add_message("Each party member gained " + str(xp_pool) + "XP.")
	EndBattleMenu.add_message("Each party member gained " + str(ap_pool) + "AP for their weapon.")
	EndBattleMenu.add_message("Each party member regained a bit of MP.")
	for string in skill_messages:
		EndBattleMenu.add_message(string)
	
	var mat_message = "Got materials:"
	var add_comma = false
	for id in range(len(mat_drops)):
		if mat_drops[id] > 0:
			mat_message += ", " if add_comma else " "
			mat_message += Global.material_names[id] + " x" + str(mat_drops[id])
			add_comma = true
			get_parent().materials[id] += mat_drops[id]
	EndBattleMenu.add_message(mat_message)
	
	if Global.rand.randf() < 1-(1/(pow(1.45,max_encounter_len))):
		var item_drop
		item_level += Global.rand.randi() % 7
		var item_type = Global.rand.randf()
		if item_type < 0.5:
			if item_level > 24:
				item_drop = Consumeable.new("Grape Bunch", 16, 0, false)
			elif item_level > 12:
				item_drop = Consumeable.new("Healing Grape", 8, 0, false)
			else:
				item_drop = Consumeable.new("Grapeseed", 4, 0, false)
		elif item_type < 0.75:
			if item_level > 24:
				item_drop = Consumeable.new("Orange Grove", 10, 1, false)
			elif item_level > 12:
				item_drop = Consumeable.new("Ripe Orange", 6, 1, false)
			else:
				item_drop = Consumeable.new("Orange Slice", 3, 1, false)
		else:
			if item_level > 24:
				item_drop = Consumeable.new("Beastly Energy", 10, 2, false)
			elif item_level > 12:
				item_drop = Consumeable.new("Instant Coffee", 6, 2, false)
			else:
				item_drop = Consumeable.new("Sparky Cola", 3, 2, false)
		
		if len(get_parent().inventory) < 24:
			get_parent().inventory.append(item_drop)
			EndBattleMenu.add_message("Got consumeable: " + item_drop.g_name)
		else:
			EndBattleMenu.add_message("The enemy dropped a " + item_drop.g_name + ", but your inventory is full.")
	
	check_level_up()

func _on_TurnManager_end_battle():
	emit_signal("end_battle")

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
