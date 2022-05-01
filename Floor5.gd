extends GridMap

var encounter_table
var encounter_levels
var respawn_point
var respawn_rotation
var l_name

signal go_to_floor

# Called when the node enters the scene tree for the first time.
func _ready():
	encounter_table = [0, 1, 2, 3]
	encounter_levels = [9, 10]
	respawn_point = Vector3(1, 1.01, -1)
	respawn_rotation = Vector3(0, 0, 0)
	l_name = "Final Floor"


func _on_ToFloor4_body_entered(body):
	emit_signal("go_to_floor", "res://Floor4.tscn", Vector3(-15, 1.01, -15), Vector3(0, -90, 0))