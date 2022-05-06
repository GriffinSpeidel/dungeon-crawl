extends Equipment

class_name Armor

var affinities

func _init(s, n, aff):
	stats = s
	g_name = n
	affinities = aff
	type = 1

func save():
	var save_dict = {
		"save_type" : 1,
		"stats" : stats,
		"g_name" : g_name,
		"affinities" : affinities
	}
	return save_dict
