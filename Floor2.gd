extends GridMap

var encounter_table
var encounter_levels
var respawn_point
var respawn_rotation
var l_name

signal go_to_floor

# Called when the node enters the scene tree for the first time.
func _ready():
	encounter_table = [1, 2]
	encounter_levels = [2, 2, 3, 3, 3, 4]
	respawn_point = Vector3(11, 1.01, 11)
	respawn_rotation = Vector3(0, 90, 0)
	l_name = "Floor 2"


func _on_ToFloor1_body_entered(body):
	emit_signal("go_to_floor", "res://Floor1.tscn", Vector3(11, 1.01, 11), Vector3(0, 90, 0))
