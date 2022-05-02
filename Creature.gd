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
var c_name
var id
var guarding

func set_hp_mp():
	self.hp_max = int((4 * self.stats[2] + 2 * self.level) * Global.damage_scale)
	self.mp_max = int(1 + 2 * self.stats[4] + self.level)
	self.hp = self.hp_max
	self.mp = self.mp_max

func set_max_hp_mp():
	self.hp_max = int((4 * self.stats[2] + 2 * self.level) * Global.damage_scale)
	self.hp = self.hp_max if self.hp > self.hp_max else self.hp
	self.mp_max = int(1 + 2 * self.stats[4] + self.level)
	self.mp = self.mp_max if self.mp > self.mp_max else self.mp
	

func attack(target, s_name, might, element, hit, crit, damage_pos):
	var attack_stat = 0 if element == Global.PHYS else 3
	var defense_stat = 2 if element == Global.PHYS else 4
	var crit_success = false
	var hit_chance = hit * (1 + (((self.stats[1] + 0.0) / target.stats[1]) - 1) / 2)
	if Global.rand.randf() < hit_chance:
		var message = c_name
		if typeof(self.id) != TYPE_NIL:
			message += ' ' + str(self.id)
		message += " attacks " + target.c_name
		if typeof(target.id) != TYPE_NIL:
			message += ' ' + str(target.id)
		message += " with " + s_name + "."
		var damage = max(((self.stats[attack_stat] * might) - (target.stats[defense_stat] / 2)), 0) * Global.rand.randf_range(0.85, 1.15) + Global.rand.randi_range(0, 1)
		damage *= target.affinities[element]
		if Global.rand.randf() < crit * self.stats[5] / target.stats[5]:
			damage *= 2
			# damage += self.stats[0] * might / 2
			crit_success = true
			message += " A critical hit!"
		if target.affinities[element] > 1:
			message += " It's super effective!"
		elif target.affinities[element] == 0:
			message += " The attack was nullified!"
		elif target.affinities[element] < 1:
			message += " It's not very effective..."
		if target.guarding:
			message += " Blocked half the damage!"
			damage /= 2
		target.hp -= int(damage * Global.damage_scale)
		message += " " + str(int(damage * Global.damage_scale)) + " damage!"
		message += (" " + target.c_name + " is defeated. ") if target.hp <= 0 else ""
		return [message, target.hp <= 0 and (target.affinities[element] > 1 or crit_success)]
	else:
		return [c_name + " attacks " + target.c_name + " with " + s_name + " and misses.", false]
