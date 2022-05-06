extends "res://Creature.gd"

var experience
var LevelMenu
var weapon
var armor

signal level_next_character

func _initialize(c_name, image):
	self.c_name = c_name
	if Global.god_mode:
		self.stats = [100, 100, 100, 100, 100, 100]
	elif Global.hard_mode:
		self.stats = [2, 2, 2, 2, 2, 2]
	else:
		self.stats = [3, 3, 3, 3, 3, 3]
	
	self.level = 1
	self.texture = load(image)
	self.guarding = false
	self.affinities = [1, 1, 1, 1, 1]
	self.experience = 0
	self.weapon = null
	self.armor = null
	set_hp_mp()

func learn_skill(skill):
	self.skills.append(skill)

func level_up():
	var level_menu_res = load("res://LevelMenu.tscn")
	LevelMenu = level_menu_res.instance()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	add_child(LevelMenu)
	self.level += 1
	self.experience -= 100
	$LevelMenu/Label.text = self.c_name + " leveled up to " + str(self.level) + "! Choose a stat to increase:"
	var i = 0
	for b in LevelMenu.get_node("Buttons").get_children():
		b.connect("pressed", self, "increase_stat", [i])
		i += 1

func increase_stat(stat):
	self.stats[stat] += 1
	if typeof(LevelMenu) != TYPE_NIL:
		LevelMenu.queue_free()
		emit_signal("level_next_character")
	self.set_hp_mp()

func equip(item):
	if item is Weapon:
		unequip_weapon()
		weapon = item
		for i in len(stats):
			stats[i] += weapon.stats[i]
	elif item is Armor:
		unequip_armor()
		armor = item
		for i in len(stats):
			stats[i] += armor.stats[i]
		affinities = armor.affinities
	self.set_max_hp_mp()

func unequip_weapon():
	if weapon != null:
		for i in len(stats):
			stats[i] -= weapon.stats[i]
		get_parent().get_parent().inventory.append(weapon)
		weapon = null
	self.set_max_hp_mp()

func unequip_armor():
	if armor != null:
		for i in len(stats):
			stats[i] -= armor.stats[i]
		get_parent().get_parent().inventory.append(armor)
		affinities = [1,1,1,1,1]
		armor = null
	self.set_max_hp_mp()

func save():
	var weapon_skills = []
	if weapon != null:
		for skill in weapon.skills:
			weapon_skills.append(skill.s_name)
	var char_skills = []
	for skill in skills:
		char_skills.append(skill.s_name)
	var save_dict = {
		"experience" : experience,
		"weapon" : null if weapon == null else weapon.save(),
		"armor" : null if armor == null else armor.save(),
		"hp" : hp,
		"hp_max" : hp_max,
		"mp" : mp,
		"mp_max" : mp_max,
		"level" : level,
		"stats" : stats,
		"affinities" : affinities,
		"skills" : char_skills,
		"texture" : texture.get_path(),
		"c_name" : c_name,
	}
	var asdf = 1
	return save_dict
