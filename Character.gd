extends "res://Creature.gd"

var guarding

func _initialize(c_name, image):
	self.c_name = c_name
	self.stats = [3, 3, 3, 3, 3, 3]
	self.level = 1
	self.texture = load(image)
	self.guarding = false
	self.affinities = [1, 1, 1, 1, 1]

	set_hp_mp()

func learn_skill(skill):
	self.skills.append(skill)
