extends "res://Creature.gd"

var type
enum {HEAD, SUIT, PLANT}

func _ready():
	pass

func set_hp():
	hp_max = (4 * stats[1] + 2 * level) * Global.damage_scale
	hp = hp_max
