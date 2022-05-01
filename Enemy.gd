extends "res://Creature.gd"

enum {HEAD, SUIT, PLANT}

var base_stats
var mat_drops

func is_equal(target):
	return self.id == target.id

func act(live_party_members):
	var choice = Global.rand.randi_range(0, len(self.skills))
	var target_pos = Global.rand.randi_range(0, len(live_party_members) - 1)
	var target = live_party_members[target_pos]
	if choice == len(self.skills):
		return attack(target, "Strike", 1, Global.PHYS, 0.9, 0.05, Vector2(100 + target_pos * 300, 550))[0]
	else:
		var skill = self.skills[choice]
		if self.hp > self.hp_max * skill.h_cost and self.mp >= skill.m_cost:
			self.hp -= self.hp_max * skill.h_cost
			self.mp -= skill.m_cost
			return attack(target, skill.s_name, skill.might, skill.element, skill.hit, skill.crit, Vector2(100 + target_pos * 300, 550))[0]
		else:
			return self.c_name + " tries to use " + skill.s_name + ", but doesn't have enough " + ("HP" if skill.h_cost > 0 else "MP") + "."
