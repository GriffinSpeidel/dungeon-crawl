extends "res://Creature.gd"

var guarding
var experience
var LevelMenu

func _initialize(c_name, image):
	self.c_name = c_name
	self.stats = [3, 3, 3, 3, 3, 3]
	self.level = 1
	self.texture = load(image)
	self.guarding = false
	self.affinities = [1, 1, 1, 1, 1]
	self.experience = 99
	set_hp_mp()

func learn_skill(skill):
	self.skills.append(skill)

func level_up():
	var level_menu_res = load("res://LevelMenu.tscn")
	LevelMenu = level_menu_res.instance()
	add_child(LevelMenu)
	$LevelMenu/Label.text = self.c_name + " leveled up! Choose a stat to increase:"
	var i = 0
	for b in LevelMenu.get_node("Buttons").get_children():
		b.connect("pressed", self, "increase_stat", [i])
		i += 1
	self.experience -= 100

func increase_stat(stat):
	stats[stat] += 1
	if typeof(LevelMenu) != TYPE_NIL:
		LevelMenu.queue_free()
