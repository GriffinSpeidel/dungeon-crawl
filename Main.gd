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
var game_finished

func _ready():
	game_finished = false
	location = get_node("Floor1")
	prepare_location()
	$Player.translation = location.respawn_point
	$Player.rotation_degrees = location.respawn_rotation
	$HUD/Heading.text = "Heading: " + str(int($Player.rotation_degrees[1]) + 180)
	
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
	char1.equip(Weapon.new([0,0,0,1,0,0], "Extension Cord", [Global.blitz_ex], [36]))
	
	char2 = character_resource.instance()
	party.append(char2)
	$PartyNode.add_child(char2)
	char2._initialize("Jin", "res://textures/Jin.png")
	char2.learn_skill(Global.lunge)
	char2.equip(Weapon.new([1,0,0,0,0,0], "Autographed Bat", [Global.eviscerate], [36]))
	
	char3 = character_resource.instance()
	party.append(char3)
	$PartyNode.add_child(char3)
	char3._initialize("Carlos", "res://textures/Carlos.png")
	char3.learn_skill(Global.sturm)
	char3.equip(Weapon.new([0,0,1,0,0,0], "Industrial Vacuum", [Global.sturm_ex], [36]))
	
	for c in party:
		c.hp = c.hp_max
		c.mp = c.mp_max
	
	encounter_rate = 0

func prepare_location():
	location.connect("go_to_floor", self, "on_Pickup_go_to_floor")
	location.connect("start_boss", self, "start_boss")
	location.connect("heal_all", self, "heal_all")

func heal_all():
	for c in party:
		c.hp = c.hp_max
		c.mp = c.mp_max

func on_Pickup_go_to_floor(new_floor, translation, rotation):
	location.queue_free()
	$Player.translation = translation
	$Player.rotation_degrees = rotation
	var new_floor_res = load(new_floor)
	var NewFloor = new_floor_res.instance()
	location = NewFloor
	add_child(NewFloor)
	$HUD/Floor.text = location.l_name
	prepare_location()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and not battle and not game_finished:
		if paused:
			$PauseMenu.clear_skill_windows()
			$PauseMenu.clear_synthesis()
			unpause()
		else:
			pause()

func start_encounter(e_res, e_level, is_boss):
	$Battle.fill_and_draw(e_res, e_level, is_boss)
	$Battle/BattleMessage.clear_messages()
	# begin battle
	battle = true
	$Battle._initialize(party)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Battle.show()
	$HUD.hide()

func start_boss():
	start_encounter([5], [12], true)
	$Battle.connect("end_battle", self, "_on_Battle_win_boss")

func _on_Battle_win_boss():
	var end_screen_res = load("res://EndGameScreen.tscn")
	var EndScreen = end_screen_res.instance()
	add_child(EndScreen)
	$HUD.queue_free()
	$PauseMenu.queue_free()
	$Battle.queue_free()
	$Player.queue_free()
	game_finished = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$EndGameScreen/ReferenceRect/Button.connect("pressed", self, "close_game")
	

func close_game():
	get_tree().quit()

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
		c.hp = max(c.hp, int(c.hp_max / 4))
	battle = false
	if not $Battle.is_boss:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Battle.hide()
	$HUD.visible = true

func _on_Battle_game_over():
	if $Battle.is_connected("end_battle", self, "_on_Battle_win_boss"):
		$Battle.disconnect("end_battle", self, "_on_Battle_win_boss")
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
		start_encounter(encounter, encounter_levels, false)
