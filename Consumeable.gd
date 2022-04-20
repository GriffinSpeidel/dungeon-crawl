extends Item

class_name Consumeable

var potency

func _init(n, p):
	g_name = n
	potency = p

func use(target):
	target.hp = min(int(target.hp + potency * Global.rand.randf_range(0.7,1.1) * Global.damage_scale), target.hp_max)
