extends Equipment

class_name Weapon

var skills
var thresholds
var ap

func _init(s, n, s_list, t_list):
	stats = s
	g_name = n
	skills = s_list
	thresholds = t_list
	ap = 0
	type = 0

func add_ap(x, character):
	if len(skills) > 0 and not character.skills.has(skills[0]):
		ap += x
		if ap >= thresholds[0]:
			thresholds.remove(0)
			ap = 0 if len(thresholds) == 0 else ap
			return skills.pop_front()
