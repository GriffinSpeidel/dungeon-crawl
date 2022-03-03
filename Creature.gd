extends Node

var hp
var hp_max
var mp
var mp_max
var level
var stats = [] # str, agi, vit, int, wis, luk
var affinities = [] # phys, fire, ice, lighting, wind (damage taken)
var texture

func attack(target, scale, element, hit, crit):
	if Global.rand.randf() < hit * self.stats[1] / target.stats[1]:
		var damage = max(((self.stats[0] * scale) - (target.stats[2] / 2)), 0) * Global.rand.randf_range(0.85, 1.15) + Global.rand.randi_range(0, 1)
		damage *= target.affinities[element]
		if Global.rand.randf() < crit * self.stats[5] / target.stats[5]:
			damage *= 2
			damage += self.stats[0] * scale / 2
			print("crit")
		target.hp -= int(damage * Global.damage_scale)
		print(int(damage * Global.damage_scale))
	else:
		print("miss")
