extends "res://Creature.gd"

var experience
var LevelMenu
var weapon
var armor

signal level_next_character

func _initialize(c_name, image):
	self.c_name = c_name
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
		if weapon != null:
			for i in len(stats):
				stats[i] -= weapon.stats[i]
			get_parent().get_parent().inventory.append(weapon)
		weapon = item
		for i in len(stats):
			stats[i] += weapon.stats[i]
	self.set_max_hp_mp()

func unequip_weapon():
	if weapon != null:
		for i in len(stats):
			stats[i] -= weapon.stats[i]
			get_parent().get_parent().inventory.append(weapon)
	self.set_max_hp_mp()

func unequip_armor():
	if armor != null:
		for i in len(stats):
			stats[i] -= armor.stats[i]
			get_parent().get_parent().inventory.append(armor)
	self.set_max_hp_mp()
