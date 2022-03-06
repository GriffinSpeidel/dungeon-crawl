extends "res://Creature.gd"

var type
enum {HEAD, SUIT, PLANT}

func act(live_party_members):
	var choice = Global.rand.randi_range(0, len(self.skills))
	var target_pos = Global.rand.randi_range(0, len(live_party_members) - 1)
	var target = live_party_members[target_pos]
	print('\nAttacking ' + target.c_name)
	if choice == len(self.skills):
		attack(target, "STRIKE", 1, Global.PHYS, 0.9, 0.05, Vector2(100 + target_pos * 300, 550))
		print('basic strike')
	else:
		var skill = self.skills[choice]
		print('used ' + skills[choice].s_name)
		attack(target, skill.s_name.to_upper(), skill.might, skill.element, skill.hit, skill.crit, Vector2(100 + target_pos * 300, 550))
