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
var materials = []

func _ready():
	location = get_node("Floor1")
	prepare_location()
	$Player.translation = location.respawn_point
	$Player.rotation_degrees = location.respawn_rotation
	
	for i in range(11):
		materials.append(0)
	
	Global.rand.randomize()
	
	inventory.append(Consumeable.new("Grapeseed", 4, 0, true))
	inventory.append(Consumeable.new("Grapeseed", 4, 0, true))
	inventory.append(Consumeable.new("Orange Slice", 3, 1, true))
	inventory.append(Consumeable.new("Instant Coffee", 4, 2, true))
	
	var character_resource = load("res://Character.tscn")
	
	char1 = character_resource.instance()
	party.append(char1)
	$PartyNode.add_child(char1)
	char1._initialize("Maya", "res://textures/Maya.png")
	char1.learn_skill(Global.blitz)
	char1.equip(Weapon.new([0,0,0,1,0,0], "Extension Cord", [Global.blitz_ex], [50]))
	
	char2 = character_resource.instance()
	party.append(char2)
	$PartyNode.add_child(char2)
	char2._initialize("Jin", "res://textures/Jin.png")
	char2.learn_skill(Global.lunge)
	char2.equip(Weapon.new([1,0,0,0,0,0], "Autographed Bat", [Global.eviscerate], [50]))
	
	char3 = character_resource.instance()
	party.append(char3)
	$PartyNode.add_child(char3)
	char3._initialize("Carlos", "res://textures/Carlos.png")
	char3.learn_skill(Global.sturm)
	char3.equip(Weapon.new([0,0,1,0,0,0], "Industrial Vacuum", [Global.sturm_ex], [50]))
	
	for c in party:
		c.hp = c.hp_max
		c.mp = c.mp_max
	
	encounter_rate = 0

func prepare_location():
	location.connect("go_to_floor", self, "on_Pickup_go_to_floor")

func on_Pickup_go_to_floor(new_floor, translation, rotation):
	location.queue_free()
	var new_floor_res = load(new_floor)
	var NewFloor = new_floor_res.instance()
	add_child(NewFloor)
	location = NewFloor
	$Player.translation = translation
	$Player.rotation_degrees = rotation
	$HUD/Floor.text = location.l_name
	prepare_location()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and not battle:
		if paused:
			$PauseMenu.clear_skill_windows()
			$PauseMenu.clear_synthesis()
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
	start_encounter([0], [1])

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

func _on_Battle_end_battle():
	for e in $Battle/EncounterNode.get_children():
		e.queue_free()
	for c in party:
		c.hp = max(c.hp, 1)
	battle = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Battle.hide()
	$HUD.visible = true

func _on_Battle_game_over():
	for e in $Battle/EncounterNode.get_children():
		e.queue_free()
	$Battle/GameOver.queue_free()
	battle = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for c in party:
		c.hp = c.hp_max
		c.mp = c.mp_max
		c.experience = 0
	$Player.translation = location.respawn_point
	$Player.rotation_degrees = location.respawn_rotation
	$Battle.hide()
	$HUD.visible = true

func _on_Player_update_danger_level(): 
	var j = 0
	for item in inventory:
		if item is Consumeable:
			item.freshness -= 1
			if item.freshness == 0:
				inventory.remove(j)
		j += 1
	encounter_rate += 0.05 * Global.encounter_rate_scale
	$HUD/Danger.text = "Danger Level: " + str(min(encounter_rate * 200 / Global.encounter_rate_scale, 100)) + "%"
	if Global.rand.randf() < encounter_rate:
		encounter_rate = 0
		$HUD/Danger.text = "Danger Level: " + str(min(encounter_rate * 200 / Global.encounter_rate_scale, 100)) + "%"
		var encounter = []
		var encounter_levels = []
		var encounter_size = encounter_size_distribution[Global.rand.randi() % len(encounter_size_distribution)]
		for i in range(encounter_size):
			encounter.append(location.encounter_table[Global.rand.randi() % len(location.encounter_table)])
			encounter_levels.append(location.encounter_levels[Global.rand.randi() % len(location.encounter_levels)])
		start_encounter(encounter, encounter_levels)
