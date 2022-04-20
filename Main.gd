extends Node

var paused = false
var char1
var char2
var char3
var battle = false
var party = []
var level_up_queue
var encounter_rate
var location
var encounter_size_distribution = [1, 1, 2, 2, 2, 3, 4]
var inventory = []

func _ready():
	Global.rand.randomize()
	
	inventory.append(Consumeable.new("Healing Grape", 4))
	inventory.append(Consumeable.new("Healing Grape", 4))

	inventory.append(Armor.new([0,0,0,0,1,0], "Asbestos Cloak", [1,0.5,2,1,1]))
	inventory.append(Weapon.new([1,0,0,1,0,0], "Icebox", [Global.eis], [20]))
	
	var character_resource = load("res://Character.tscn")
	char1 = character_resource.instance()
	party.append(char1)
	$PartyNode.add_child(char1)
	char1._initialize("foop", "res://textures/Face1.png")
	char1.learn_skill(Global.lunge)
	char1.learn_skill(Global.feuer)
	char1.learn_skill(Global.sturm)
	char1.learn_skill(Global.blitz)
	
	char1.equip(Weapon.new([2,0,0,0,0,0], "Baseball Bat", [Global.lunge], [20]))
	
	char2 = character_resource.instance()
	party.append(char2)
	$PartyNode.add_child(char2)
	char2._initialize("shoop", "res://textures/Face1.png")
	char2.learn_skill(Global.feuer)
	
	char2.equip(Armor.new([0,0,1,0,0,0], "Winter Coat", [1,2,0.5,1,1]))
	
	char3 = character_resource.instance()
	party.append(char3)
	$PartyNode.add_child(char3)
	char3._initialize("woop", "res://textures/Face1.png")
	char3.learn_skill(Global.feuer)
	char3.learn_skill(Global.eis)
	
	location = get_node("OfficeGrid")
	encounter_rate = 0

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and not battle:
		if paused:
			unpause()
		else:
			pause()

func _on_OfficeGrid_pickup():
	#var level = get_node("OfficeGrid")
	#$OfficeGrid.queue_free()
	#var next_level_resource = load("res://Office2.tscn")
	#var next_level = next_level_resource.instance()
	#add_child(next_level)
	#next_level.connect("pickup2", self, "_on_Office2_pickup")
	start_encounter([0], 1)

func start_encounter(e_res, e_level):
	$Battle.fill_and_draw(e_res, e_level)
	$Battle/BattleMessage.clear_messages()
	# begin battle
	battle = true
	$Battle._initialize(party)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Battle.show()
	$HUD.hide()

func _on_Office2_pickup():
	pass

func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	paused = true
	$HUD.visible = false
	$PauseMenu.update_portraits()
	$PauseMenu.update_equipment()
	$PauseMenu.update_inventory()
	$PauseMenu.show()

func unpause():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	paused = false
	$HUD.visible = true
	$PauseMenu.hide()

func _on_Battle_end_battle(manager_index):
	for e in $Battle/EncounterNode.get_children():
		e.queue_free()
	battle = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Battle.hide()
	$HUD.visible = true
	$Battle.get_child(manager_index).queue_free()


func _on_Battle_game_over():
	for e in $Battle/EncounterNode.get_children():
		e.queue_free()
	battle = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Battle.hide()

func _on_Battle_win(manager_index):
	# $Battle.print_tree_pretty()
	for e in $Battle/EncounterNode.get_children():
		e.queue_free()
	battle = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Battle.hide()
	$HUD.visible = true
	$Battle.get_child(manager_index).queue_free()
	check_level_up()

func check_level_up():
	for c in party:
		if c.experience >= 100:
			level_up_character(c)
			return true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	return false
	
func level_up_character(c):
	c.level_up()
	c.connect("level_next_character", self, "check_level_up")

func _on_Player_update_danger_level(): 
	encounter_rate += 0.05 * Global.encounter_rate_scale
	$HUD/Label.text = "Danger Level: " + str(min(encounter_rate * 200 / Global.encounter_rate_scale, 100)) + "%"
	if Global.rand.randf() < encounter_rate:
		encounter_rate = 0
		var encounter = []
		var encounter_size = encounter_size_distribution[Global.rand.randi() % len(encounter_size_distribution)]
		for i in range(encounter_size):
			encounter.append(location.encounter_table[Global.rand.randi() % len(location.encounter_table)])
		start_encounter(encounter, location.encounter_levels[Global.rand.randi() % len(location.encounter_levels)])
