extends "res://Creature.gd"

var type
enum {HEAD, SUIT, PLANT}

func act(live_party_members):
	var choice = Global.rand.randi_range(0, len(self.skills))
	var target = live_party_members[Global.rand.randi_range(0, len(live_party_members) - 1)]
	print('\nAttacking ' + target.c_name)
	if choice == len(self.skills):
		self.attack(target, 1, Global.PHYS, 0.9, 0.05)
		print('basic strike')
	else:
		var skill = self.skills[choice]
		print('used ' + str(skills[choice]))
		self.attack(target, skill.might, skill.element, skill.hit, skill.crit)
