extends "res://Creature.gd"

var c_name
var guarding

func _initialize(c_name, image):
	self.c_name = c_name
	self.stats = [3, 3, 3, 3, 3, 3]
	self.level = 1
	self.texture = load(image)
	self.guarding = false
	set_hp_mp()

func set_hp_mp():
	self.hp_max = (4 * self.stats[1] + 2 * self.level) * Global.damage_scale
	self.mp_max = 1 + 2 * self.stats[3] + self.level
	self.hp = self.hp_max
	self.mp = self.mp_max
