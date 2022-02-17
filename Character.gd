extends "res://Creature.gd"

var c_name
var hp
var hp_max
var mp
var mp_max
var level
var stats = []
var texture
var guarding

func _initialize(c_name, image):
	self.c_name = c_name
	self.stats = [3, 3, 3, 3, 3, 3]
	self.level = 1
	self.texture = load(image)
	self.guarding = false
	set_hp_mp()

func set_hp_mp():
	hp_max = (4 * stats[1] + 2 * level) * Global.damage_scale
	mp_max = 1 + 2 * stats[3] + level
	hp = hp_max
	mp = mp_max
