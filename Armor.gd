extends Equipment

class_name Armor

var affinities

func _init(s, n, aff):
	stats = s
	g_name = n
	affinities = aff
	type = 1
