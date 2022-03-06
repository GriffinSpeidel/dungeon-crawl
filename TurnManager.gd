extends Node

var encounter
var party
var active
var EButtons
var SkillMenu
signal end_battle

func _ready():
	encounter = get_parent().get_node("EncounterNode").get_children()
	party = get_parent().get_parent().party
	active = party[get_parent().current]

func _on_StrikeButton_pressed():
	get_target(1, "Strike", Global.PHYS, 0.9, 0.05, 0, 0)

func get_target(might, s_name, type, hit, crit, h_cost, m_cost):
	var enemy_buttons = []
	$BattleMenu.hide()
	if has_node("SkillMenu"):
		$SkillMenu.queue_free()
	EButtons = Control.new()
	add_child(EButtons)
	for i in range(len(encounter)):
		enemy_buttons.append(Button.new())
		enemy_buttons[i].rect_position = (Vector2(412 - 110 * (len(encounter) - 1) + i * 220, 350))
		enemy_buttons[i].rect_size = (Vector2(200, 50))
		enemy_buttons[i].mouse_default_cursor_shape = 2
		enemy_buttons[i].enabled_focus_mode = 0
		enemy_buttons[i].text = "Select " + encounter[i].c_name
		enemy_buttons[i].connect("pressed", self, "_on_EButton_pressed", [i, s_name, might, type, hit, crit, h_cost, m_cost])
		#                                                enemy selected, might, type, hit, crit
		EButtons.add_child(enemy_buttons[i])
	var Cancel = Button.new()
	EButtons.add_child(Cancel)
	Cancel.rect_position = Vector2(332 - 110 * (len(encounter) - 1), 350)
	Cancel.rect_size = Vector2(60, 50)
	Cancel.text = "Cancel"
	Cancel.mouse_default_cursor_shape = 2
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
	SkillControl.rect_min_size = Vector2(260, (len(active.skills) + 1) * 50)
	for i in len(active.skills):
		SkillControl.add_child(Button.new())
		var button_text = active.skills[i].s_name + " "
		if active.skills[i].m_cost > 0:
			button_text += str(active.skills[i].m_cost) + "MP"
		else:
			button_text += str(int(active.skills[i].h_cost * active.hp_max)) + "HP"
		SkillControl.get_child(i).text = button_text
		SkillControl.get_child(i).rect_size = Vector2(260, 50)
		SkillControl.get_child(i).rect_position = Vector2(0, 50 * i)
		SkillControl.get_child(i).mouse_default_cursor_shape = 2
		SkillControl.get_child(i).enabled_focus_mode = 0
		SkillControl.get_child(i).connect("pressed", self, "get_target", active.skills[i].get_stats())
		# need to put conditional for multitarget
	SkillControl.add_child(Button.new())
	SkillControl.get_child(len(active.skills)).text = "Cancel"
	SkillControl.get_child(len(active.skills)).rect_size = Vector2(260, 50)
	SkillControl.get_child(len(active.skills)).rect_position = Vector2(0, 50 * len(active.skills) + 1)
	SkillControl.get_child(len(active.skills)).mouse_default_cursor_shape = 2
	SkillControl.get_child(len(active.skills)).enabled_focus_mode = 0
	SkillControl.get_child(len(active.skills)).connect("pressed", self, "_on_Cancel_pressed")

func _on_Cancel_pressed():
	SkillMenu.queue_free()
	$BattleMenu.show()

func _on_GuardButton_pressed():
	pass # Replace with function body.

func _on_FleeButton_pressed():
	emit_signal("end_battle")

func _on_EButton_pressed(i, s_name, might, element, hit, crit, h_cost, m_cost):
	if active.mp >= m_cost and active.hp >= int(active.hp_max * h_cost):
		var message = active.attack(encounter[i], s_name, might, element, hit, crit, Vector2(450 - 110 * (len(encounter) - 1) + i * 220, 150))
		active.hp -= int(active.hp_max * h_cost)
		active.mp -= m_cost
		#for i in range(len(encounter)):
		#	if encounter[i].hp <= 0:
		#		encounter[i].queue_free()
		#		encounter.remove(i)
		#		i -= 1
		get_parent().update_enemy_health_box(i)
		get_parent().update_player_health()
		get_parent().turn_end(message)
	else:
		get_parent().add_message("Insufficient MP/HP")
		EButtons.queue_free()
		$BattleMenu.show()
	#EButtons.queue_free()
	#$BattleMenu.show()
