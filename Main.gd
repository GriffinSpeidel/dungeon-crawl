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
	if Input.is_action_pressed("funny_mode"):
		Global.damage_scale = 999
	if Input.is_action_pressed("god_mode"):
		Global.god_mode = true
	elif Input.is_action_pressed("hard_mode"):
		Global.hard_mode = true
	
	game_finished = false
	location = get_node("Floor1")
	prepare_location()
	$Player.translation = location.respawn_point
	$Player.rotation_degrees = location.respawn_rotation
	update_heading()
	
	for i in range(11):
		materials.append(0)
	
	Global.rand.randomize()
	
	inventory.append(Consumeable.new("Grapeseed", 6, 0, true))
	inventory.append(Consumeable.new("Grapeseed", 6, 0, true))
	inventory.append(Consumeable.new("Orange Slice", 3, 1, true))
	inventory.append(Consumeable.new("Sparky Cola", 4, 2, true))
	
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
	char2.equip(Weapon.new([1,0,0,0,0,0], "Sturdy Broom", [Global.eviscerate], [36]))
	
	char3 = character_resource.instance()
	party.append(char3)
	$PartyNode.add_child(char3)
	char3._initialize("Carlos", "res://textures/Carlos.png")
	char3.learn_skill(Global.sturm)
	char3.equip(Weapon.new([0,0,1,0,0,0], "Hand Vacuum", [Global.sturm_ex], [36]))
	
	for c in party:
		c.hp = c.hp_max
		c.mp = c.mp_max
	
	encounter_rate = 0

func update_heading():
	var rot = $Player.rotation_degrees[1] + 180
	var dir = ""
	if rot < 22.5 or rot > 337.5:
		dir = "South"
	elif rot < 67.5:
		dir = "Southeast"
	elif rot < 112.5:
		dir = "East"
	elif rot < 157.5:
		dir = "Northeast"
	elif rot < 202.5:
		dir = "North"
	elif rot < 247.5:
		dir = "Northwest"
	elif rot < 292.5:
		dir = "West"
	elif rot <= 337.5:
		dir = "Southwest"
	$HUD/Heading.text = dir

func prepare_location():
	location.connect("go_to_floor", self, "on_Pickup_go_to_floor")
	location.connect("start_boss", self, "start_boss")
	location.connect("heal_all", self, "heal_all")
	if location.has_node("ItemPickups"):
		for child in location.get_node("ItemPickups").get_children():
			child.connect("body_entered", self, "add_item", [child])

func add_item(body, pickup):
	if len(inventory) < 24:
		$HUD/Notifs.text = "Got item: " + pickup.item.g_name +"!"
		pickup.queue_free()
		inventory.append(pickup.item)
	else:
		$HUD/Notifs.text = "Your inventory is full."

func heal_all():
	$HUD/Notifs.text = "The party's health and magic are restored."
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

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and not battle and not game_finished:
		if paused:
			$PauseMenu.clear_skill_windows()
			$PauseMenu.clear_synthesis()
			$PauseMenu.clear_char_buttons()
			$PauseMenu.enable_bottom_buttons()
			$PauseMenu.clear_system()
			unpause()
		else:
			pause()
	if Input.is_action_just_pressed("toggle_fulscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

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
	var buff_boss = false
	for c in party:
		if c.weapon.g_name == "Excalibur":
			buff_boss = true
			break
	if buff_boss:
		start_encounter([4, 6, 5], [26, 30, 26], true)
	else:
		start_encounter([4, 6, 5], [10, 16, 10], true)
	$Battle.connect("end_battle", self, "_on_Battle_win_boss")

func _on_Battle_win_boss():
	for c in party:
		if c.weapon.g_name == "Excalibur":
			Global.true_ending = true
			break
	var end_screen_res = load("res://EndGameScreen.tscn")
	var EndScreen = end_screen_res.instance()
	add_child(EndScreen)
	$HUD.queue_free()
	$PauseMenu.queue_free()
	$Battle.queue_free()
	$Player.queue_free()
	game_finished = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func pause():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	paused = true
	$HUD.visible = false
	$PauseMenu.update_portraits()
	$PauseMenu.update_equipment()
	$PauseMenu.update_inventory()
	$PauseMenu/Details/Label.text = ""
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
	Global.steps_taken += 1
	var j = 0
	for item in inventory:
		if item is Consumeable:
			item.freshness -= 1
			if item.freshness == 0:
				inventory.remove(j)
		j += 1
	
	var notif = ""
	for item in inventory:
		if item is Consumeable and item.freshness <= 5:
			notif += item.g_name + " will expire in " + str(item.freshness) + " steps.\n"
	$HUD/Notifs.text = notif
	
	encounter_rate += 0.05 * Global.encounter_rate_scale
	$HUD/Danger.text = "Danger Level: " + str(min(encounter_rate * 200 / Global.encounter_rate_scale, 100)) + "%"
	if Global.rand.randf() < (encounter_rate * encounter_rate / 0.5):
		encounter_rate = 0
		$HUD/Danger.text = "Danger Level: 0%"
		var encounter = []
		var encounter_levels = []
		var encounter_size = encounter_size_distribution[Global.rand.randi() % len(encounter_size_distribution)]
		for i in range(encounter_size):
			encounter.append(location.encounter_table[Global.rand.randi() % len(location.encounter_table)])
			encounter_levels.append(location.encounter_levels[Global.rand.randi() % len(location.encounter_levels)])
		start_encounter(encounter, encounter_levels, false)

func save():
	var save_dict = {
		"pos_x" : $Player.translation[0],
		"pos_z" : $Player.translation[2],
		"rot_x" : $Player.rotation_degrees[0],
		"rot_y" : $Player.rotation_degrees[1],
		"rot_z" : $Player.rotation_degrees[2],
		"location" : location.save(),
		"encounter_rate" : encounter_rate,
		"materials" : materials
	}
	return save_dict

func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	#save_game.store_line(to_json(Global.save()))
	save_game.store_line(to_json(save())) # main save
	for character in party: # 3 lines of character save
		save_game.store_line(to_json(character.save()))
	var inventory_save = []
	for item in inventory:
		inventory_save.append(item.save())
	save_game.store_line(to_json(inventory_save)) # 1 line of inventory save
	save_game.store_line(to_json(Global.save())) # 1 line of Global save
	save_game.close()

func load_game():
	var save_game  = File.new()
	save_game.open("user://savegame.save", File.READ)
	if not save_game.file_exists("user://savegame.save"):
		return null
	
	#var global_data = parse_json(save_game.get_line())
	#for key in global_data.keys():
#		Global.set(key, global_data[key])
	
	var main_data = parse_json(save_game.get_line())
	$Player.translation = Vector3(main_data["pos_x"], 1.01, main_data["pos_z"])
	$Player.rotation_degrees = Vector3(main_data["rot_x"], main_data["rot_y"], main_data["rot_z"])
	
	location.queue_free()
	var location_data = main_data["location"]
	location = load(location_data["filename"]).instance()
	location.load_pickups(location_data["pickup_array"])
		
	add_child(location)
	$HUD/Floor.text = location.l_name
	$HUD/Notifs.text = ""
	update_heading()
	prepare_location()
	
	encounter_rate = main_data["encounter_rate"]
	$HUD/Danger.text = "Danger Level: " + str(min(encounter_rate * 200 / Global.encounter_rate_scale, 100)) + "%"
	
	materials = main_data["materials"]
	
	for character in party:
		var char_data = parse_json(save_game.get_line())
		var weapon_data = char_data["weapon"]
		if weapon_data == null:
			character.weapon = null
		else:
			character.weapon = Weapon.new(weapon_data["stats"], weapon_data["g_name"], [], weapon_data["thresholds"])
			var skill_list = []
			for s_name in weapon_data["skills"]:
				for skill in Global.skills:
					if skill.s_name == s_name:
						skill_list.append(skill)
						break
			character.weapon.skills = skill_list
			character.weapon.ap = weapon_data["ap"]
		
		var armor_data = char_data["armor"]
		character.armor = null if armor_data == null else Armor.new(armor_data["stats"], armor_data["g_name"], armor_data["affinities"])
		
		character.texture = load(char_data["texture"])
		
		var char_skills = []
		for s_name in char_data["skills"]:
			for skill in Global.skills:
				if skill.s_name == s_name:
					char_skills.append(skill)
					break
		character.skills = char_skills
		
		for key in char_data.keys():
			if key == "weapon" or key == "armor" or key == "texture" or key == "skills":
				continue
			else:
				character.set(key, char_data[key])
	
	var inventory_data = parse_json(save_game.get_line())
	inventory = []
	for item_dict in inventory_data:
		if item_dict["save_type"] == 0:
			var NewConsumeable = Consumeable.new(item_dict["g_name"], item_dict["potency"], item_dict["variety"], true)
			NewConsumeable.freshness = item_dict["freshness"]
			inventory.append(NewConsumeable)
		elif item_dict["save_type"] == 1:
			inventory.append(Armor.new(item_dict["stats"], item_dict["g_name"], item_dict["affinities"]))
		elif item_dict["save_type"] == 2:
			var NewWeapon = Weapon.new(item_dict["stats"], item_dict["g_name"], [], item_dict["thresholds"])
			var skill_list = []
			for s_name in item_dict["skills"]:
				for skill in Global.skills:
					if skill.s_name == s_name:
						skill_list.append(skill)
						break
			NewWeapon.skills = skill_list
			NewWeapon.ap = item_dict["ap"]
			inventory.append(NewWeapon)
	
	var global_data = parse_json(save_game.get_line())
	for key in global_data.keys():
		Global.set(key, global_data[key])
	
	$PauseMenu.clear_skill_windows()
	$PauseMenu._on_SystemMenu_close_sys()
	unpause()
