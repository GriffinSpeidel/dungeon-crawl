extends Node

var encounter
var party
var active
var EButtons
var CButtons
var CharCancel
var SkillMenu
var ItemMenu
var ReapMenu
signal end_battle
signal update_boxes
signal win

func _ready():
	encounter = get_parent().get_node("EncounterNode").get_children()
	party = get_parent().get_parent().party
	active = party[get_parent().current]

func _on_StrikeButton_pressed():
	get_target(1, "Strike", Global.PHYS, 0.9, 0.05, 0, 0)

func get_target(might, s_name, type, hit, crit, h_cost, m_cost):
	encounter = get_parent().get_node("EncounterNode").get_children()
	var enemy_buttons = []
	$BattleMenu.hide()
	if has_node("SkillMenu"):
		$SkillMenu.queue_free()
	EButtons = Control.new()
	add_child(EButtons)
	enemy_buttons = []
	for i in range(len(encounter)):
		enemy_buttons.append(Button.new())
		enemy_buttons[i].rect_position = Vector2(412 - 110 * (len(encounter) - 1) + i * 220, 350)
		enemy_buttons[i].rect_size = Vector2(200, 50)
		enemy_buttons[i].mouse_default_cursor_shape = 2
		enemy_buttons[i].enabled_focus_mode = 0
		enemy_buttons[i].text = "Select " + encounter[i].c_name + ' ' + str(encounter[i].id)
		enemy_buttons[i].connect("pressed", self, "_on_EButton_pressed", [i, s_name, might, type, hit, crit, h_cost, m_cost])
		#                                                enemy selected, might, type, hit, crit
		EButtons.add_child(enemy_buttons[i])
	var Cancel = Button.new()
	EButtons.add_child(Cancel)
	Cancel.rect_position = Vector2(332 - 110 * (len(encounter) - 1), 350)
	Cancel.rect_size = Vector2(60, 50)
	Cancel.text = "Cancel"
	Cancel.mouse_default_cursor_shape = 2
	Cancel.enabled_focus_mode = 0
	Cancel.connect("pressed", self, "_on_ECancel_pressed")

func _on_ECancel_pressed():
	$BattleMenu.show()
	EButtons.queue_free()

func _on_SkillButton_pressed():
	var current = get_parent().current
	$BattleMenu.hide()
	# connect selected skill button to on ebutton pressed with correct stats
	SkillMenu = ScrollContainer.new()
	add_child(SkillMenu)
	SkillMenu.name = "SkillMenu"
	SkillMenu.rect_position = Vector2(100 + 300 * current, 350)
	SkillMenu.rect_size = Vector2(272, 100)
	var SkillControl = Control.new()
	SkillMenu.add_child(SkillControl)
	SkillControl.rect_min_size = Vector2(260, (len(active.skills) + 1) * 25)
	for i in len(active.skills):
		SkillControl.add_child(Button.new())
		var button_text = active.skills[i].s_name + " "
		if active.skills[i].m_cost > 0:
			button_text += str(active.skills[i].m_cost) + "MP"
		else:
			button_text += str(int(active.skills[i].h_cost * active.hp_max)) + "HP"
		SkillControl.get_child(i).text = button_text
		SkillControl.get_child(i).rect_size = Vector2(260, 25)
		SkillControl.get_child(i).rect_position = Vector2(0, 25 * i)
		SkillControl.get_child(i).mouse_default_cursor_shape = 2
		SkillControl.get_child(i).enabled_focus_mode = 0
		SkillControl.get_child(i).connect("pressed", self, "get_target", active.skills[i].get_stats())
		# need to put conditional for multitarget
	SkillControl.add_child(Button.new())
	SkillControl.get_child(len(active.skills)).text = "Cancel"
	SkillControl.get_child(len(active.skills)).rect_size = Vector2(260, 25)
	SkillControl.get_child(len(active.skills)).rect_position = Vector2(0, 25 * len(active.skills))
	SkillControl.get_child(len(active.skills)).mouse_default_cursor_shape = 2
	SkillControl.get_child(len(active.skills)).enabled_focus_mode = 0
	SkillControl.get_child(len(active.skills)).connect("pressed", self, "clear_SkillMenu")

func clear_SkillMenu():
	if typeof(SkillMenu) != TYPE_NIL:
		SkillMenu.queue_free()
	$BattleMenu.show()

func clear_ItemMenu():
	if typeof(ItemMenu) != TYPE_NIL:
		ItemMenu.queue_free()
	$BattleMenu.show()

func _on_GuardButton_pressed():
	active.guarding = true
	get_parent().turn_end(active.c_name + " puts up their guard.")

func _on_FleeButton_pressed():
	emit_signal("end_battle")

func _on_EButton_pressed(i, s_name, might, element, hit, crit, h_cost, m_cost):
	if active.mp >= m_cost and active.hp >= int(active.hp_max * h_cost):
		var attack_result = active.attack(encounter[i], s_name, might, element, hit, crit, Vector2(450 - 110 * (len(encounter) - 1) + i * 220, 150))
		var message = attack_result[0]
		active.hp -= int(active.hp_max * h_cost)
		active.mp -= m_cost
		get_parent().update_enemy_health_box(i)
		get_parent().update_player_health()
		if attack_result[1]:
			var reap_res = load("res://Reap.tscn")
			ReapMenu = reap_res.instance()
			ReapMenu.rect_position = Vector2(287, 350)
			ReapMenu._initialize(active, encounter[i])
			ReapMenu.connect("reap_health", self, "_on_ReapMenu_reap_health")
			ReapMenu.connect("reap_magic", self, "_on_ReapMenu_reap_magic")
			ReapMenu.connect("reap_xp", self, "_on_ReapMenu_reap_xp")
			$BattleMenu.hide()
			EButtons.queue_free()
			get_parent().add_message(message)
			add_child(ReapMenu)
		elif check_enemy_hp(message): # returns true if enemies are still alive
			get_parent().turn_end(message)
	else:
		get_parent().add_message("Insufficient MP/HP")
		EButtons.queue_free()
		$BattleMenu.show()
	emit_signal("update_boxes")

func check_enemy_hp(message):
	var i = 0
	for e in encounter:
		if e.hp <= 0:
			var avg_level = (party[0].level + party[1].level + party[2].level) / 3
			get_parent().xp_pool += int(20 + (e.level - avg_level) * 10)
			get_parent().ap_pool += e.level
			get_parent().item_level += e.level
			get_parent().remove_from_order(e)
			encounter.remove(i)
			e.queue_free()
		i += 1
	if len(encounter) == 0:
		get_parent().add_message(message)
		emit_signal("win")
		return false
	else:
		return true

func _on_ItemButton_pressed():
	var current = get_parent().current
	var inventory = get_parent().get_parent().inventory
	$BattleMenu.hide()
	ItemMenu = ScrollContainer.new()
	add_child(ItemMenu)
	ItemMenu.name = "ItemMenu"
	ItemMenu.rect_position = Vector2(100 + 300 * current, 350)
	ItemMenu.rect_size = Vector2(272, 100)
	var ItemControl = Control.new()
	ItemMenu.add_child(ItemControl)
	var consumeables = []
	for item in inventory:
		if item is Consumeable:
			consumeables.append(item)
	ItemControl.rect_min_size = Vector2(260, (len(consumeables) + 1) * 25)
	for i in len(consumeables):
		ItemControl.add_child(Button.new())
		ItemControl.get_child(i).text = consumeables[i].g_name + " " + str(consumeables[i].freshness)
		ItemControl.get_child(i).rect_size = Vector2(260, 25)
		ItemControl.get_child(i).rect_position = Vector2(0, 25 * i)
		ItemControl.get_child(i).mouse_default_cursor_shape = 2
		ItemControl.get_child(i).enabled_focus_mode = 0
		ItemControl.get_child(i).connect("pressed", self, "get_character", [consumeables[i]])
	ItemControl.add_child(Button.new())
	ItemControl.get_child(len(consumeables)).text = "Cancel"
	ItemControl.get_child(len(consumeables)).rect_size = Vector2(260, 25)
	ItemControl.get_child(len(consumeables)).rect_position = Vector2(0, 25 * len(consumeables))
	ItemControl.get_child(len(consumeables)).mouse_default_cursor_shape = 2
	ItemControl.get_child(len(consumeables)).enabled_focus_mode = 0
	ItemControl.get_child(len(consumeables)).connect("pressed", self, "clear_ItemMenu")

func get_character(item):
	var character_buttons = []
	$BattleMenu.hide()
	if has_node("ItemMenu"):
		$ItemMenu.queue_free()
	CButtons = Control.new()
	CButtons.rect_position = Vector2(93, 448)
	add_child(CButtons)
	character_buttons = []
	for i in range(3):
		if party[i].hp > 0:
			character_buttons.append(Button.new())
			character_buttons[i].rect_position = Vector2(300 * i, 0)
			character_buttons[i].mouse_default_cursor_shape = 2
			character_buttons[i].enabled_focus_mode = 0
			character_buttons[i].icon = load("res://textures/Face1.png")
			character_buttons[i].connect("pressed", self, "_on_CButton_pressed", [item, i])
			#                                                                item selected, character selected
			CButtons.add_child(character_buttons[i])
	CharCancel = Button.new()
	add_child(CharCancel)
	CharCancel.rect_position = Vector2(18, 475)
	CharCancel.rect_size = Vector2(60, 50)
	CharCancel.text = "Cancel"
	CharCancel.name = "CCancel"
	CharCancel.mouse_default_cursor_shape = 2
	CharCancel.enabled_focus_mode = 0
	CharCancel.connect("pressed", self, "_on_CCancel_pressed")

func _on_CButton_pressed(item, i):
	var message = item.use(party[i])
	get_parent().update_player_health()
	var inventory = get_parent().get_parent().inventory
	for j in range(len(inventory)):
		if item == inventory[j]:
			inventory.remove(j)
			break
	get_parent().turn_end(message)

func _on_CCancel_pressed():
	$BattleMenu.show()
	CharCancel.queue_free()
	CButtons.queue_free()

func _on_ReapMenu_reap_health(character, enemy, hp):
	character.hp += hp
	character.hp = character.hp_max if character.hp > character.hp_max else character.hp
	clear_reap(character, enemy, str(hp) + "HP")

func _on_ReapMenu_reap_magic(character, enemy, mp):
	character.mp += mp
	character.mp = character.mp_max if character.mp > character.mp_max else character.mp
	clear_reap(character, enemy, str(mp) + "MP")

func _on_ReapMenu_reap_xp(character, enemy, xp):
	character.experience += xp
	clear_reap(character, enemy, str(xp) + "XP")

func clear_reap(character, enemy, bonus):
	get_parent().update_player_health()
	ReapMenu.queue_free()
	var message = character.c_name + " reaps " + enemy.c_name + " for " + bonus + "!"
	if check_enemy_hp(message):
		get_parent().turn_end(message)
