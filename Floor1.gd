extends GridMap

var encounter_table
var encounter_levels
var respawn_point
var respawn_rotation
var l_name

signal go_to_floor

# Called when the node enters the scene tree for the first time.
func _ready():
	encounter_table = [0, 3]
	encounter_levels = [1, 1, 1, 2]
	respawn_point = Vector3(-13, 1.01, -9)
	respawn_rotation = Vector3(0, -90, 0)
	l_name = "Floor 1"

func _on_ToFloor2_body_entered(body):
	emit_signal("go_to_floor", "res://Floor2.tscn", Vector3(11, 1.01, 11), Vector3(0, 90, 0))
