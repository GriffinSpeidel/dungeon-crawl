extends Item

class_name Consumeable

var potency
var freshness
var variety
var description

func _init(n, p, v, full):
	g_name = n
	potency = p
	variety = v # 0 is hp, 1 is mp, 2 is revival
	if variety == 0:
		freshness = 40 if full else Global.rand.randi() % 21 + 20
		description = "Heals around " + str(potency * Global.damage_scale) + "HP"
	elif variety == 1:
		freshness = 20 if full else Global.rand.randi() % 11 + 10
		description = "Restores around " + str(potency) + "MP"
	else:
		freshness = 80 if full else Global.rand.randi() % 36 + 45
		description = "Revives and heals to around " + str(potency * Global.damage_scale) + "HP"
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

func save():
	var save_dict = {
		"save_type" : 0,
		"g_name" : g_name,
		"potency" : potency,
		"variety" : variety,
		"freshness" : freshness
	}
	return save_dict
