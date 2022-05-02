extends Item

class_name Consumeable

var potency
var freshness
var variety

func _init(n, p, v, full):
	g_name = n
	potency = p
	variety = v # 0 is hp, 1 is mp, 2 is revival
	if variety == 0:
		freshness = 40 if full else Global.rand.randi() % 21 + 20
	elif variety == 1:
		freshness = 20 if full else Global.rand.randi() % 11 + 10
	else:
		freshness = 30 if full else Global.rand.randi() % 16 + 15
	type = 2

func use(target):
	if variety == 0:
		var effect = int(potency * Global.rand.randf_range(0.9,1.1) * Global.damage_scale)
		target.hp = min(target.hp + effect, target.hp_max)
		return target.c_name + " heals by " + str(effect) + "HP"
	elif variety == 1:
		var effect = int(potency * Global.rand.randf_range(0.9, 1.1))
		target.mp = min(target.mp + effect, target.mp_max)
		return target.c_name + " restores " + str(effect) + "MP"
	else:
		var effect = int(potency * Global.rand.randf_range(0.9,1.1) * Global.damage_scale)
		target.hp = effect
		return target.c_name + " is revived to " + str(effect) + "HP"
