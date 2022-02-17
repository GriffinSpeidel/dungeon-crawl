extends "res://Creature.gd"

enum {HEAD, SUIT, PLANT}

func _ready():
	pass

func set_hp():
	hp_max = (4 * stats[1] + 2 * level) * Global.damage_scale
	hp = hp_max

var hp
var hp_max
var stats = []
var level
var type
