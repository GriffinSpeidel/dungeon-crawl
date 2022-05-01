extends GridMap

var encounter_table
var encounter_levels
var respawn_point
var respawn_rotation
var l_name

signal go_to_floor

# Called when the node enters the scene tree for the first time.
func _ready():
	encounter_table = [2, 3, 4]
	encounter_levels = [6, 7, 7, 8]
	respawn_point = Vector3(13, 1.01, 13)
	respawn_rotation = Vector3(0, 90, 0)
	l_name = "Floor 4"


func _on_ToFloor3_body_entered(body):
	emit_signal("go_to_floor", "res://Floor3.tscn", Vector3(13, 1.01, 13), Vector3(0, 90, 0))

func _on_ToFloor5_body_entered(body):
	emit_signal("go_to_floor", "res://Floor5.tscn", Vector3(1, 1.01, -1), Vector3(0, 0, 0))
