extends GridMap

var encounter_table
var encounter_levels
var respawn_point
var respawn_rotation

# Called when the node enters the scene tree for the first time.
func _ready():
	encounter_table = [0, 3]
	encounter_levels = [1, 1, 1, 2]
	respawn_point = Vector3(-13, 1.01, -9)
	respawn_rotation = Vector3(0, -90, 0)
