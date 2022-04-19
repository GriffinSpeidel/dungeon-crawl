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
