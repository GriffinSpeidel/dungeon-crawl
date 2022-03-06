extends Node

var hp
var hp_max
var mp
var mp_max
var level
var stats = [] # str, agi, vit, int, wis, luk
var affinities = [] # phys, fire, ice, lighting, wind (damage taken)
var skills = []
var texture


func set_hp_mp():
	self.hp_max = (4 * self.stats[1] + 2 * self.level) * Global.damage_scale
	self.mp_max = 1 + 2 * self.stats[3] + self.level
	self.hp = self.hp_max
	self.mp = self.mp_max

func attack(target, might, element, hit, crit):	
	var attack_stat = 0 if element == Global.PHYS else 3
	var defense_stat = 2 if element == Global.PHYS else 4
	if Global.rand.randf() < hit * self.stats[1] / target.stats[1]:
		var damage = max(((self.stats[attack_stat] * might) - (target.stats[defense_stat] / 2)), 0) * Global.rand.randf_range(0.85, 1.15) + Global.rand.randi_range(0, 1)
		damage *= target.affinities[element]
		if Global.rand.randf() < crit * self.stats[5] / target.stats[5]:
			damage *= 2
			damage += self.stats[0] * might / 2
			print("crit")
		target.hp -= int(damage * Global.damage_scale)
		print(int(damage * Global.damage_scale))
	else:
		print("miss")
