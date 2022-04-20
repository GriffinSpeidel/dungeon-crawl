extends Item

class_name Consumeable

var potency

func _init(n, p):
	g_name = n
	potency = p

func use(target):
	var effect = int(potency * Global.rand.randf_range(0.7,1.1) * Global.damage_scale)
	target.hp = min(target.hp + effect, target.hp_max)
	return target.c_name + " heals by " + str(effect) + "HP"
