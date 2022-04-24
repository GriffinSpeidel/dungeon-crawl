extends Item

class_name Consumeable

var potency
var freshness

func _init(n, p):
	g_name = n
	potency = p
	freshness = Global.rand.randi() % 21 + 10
	type = 2

func use(target):
	var effect = int(potency * Global.rand.randf_range(0.7,1.1) * Global.damage_scale)
	target.hp = min(target.hp + effect, target.hp_max)
	return target.c_name + " heals by " + str(effect) + "HP"
