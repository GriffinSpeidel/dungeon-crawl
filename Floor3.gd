extends GridMap

var encounter_table
var encounter_levels
var respawn_point
var respawn_rotation
var l_name

signal go_to_floor

# Called when the node enters the scene tree for the first time.
func _ready():
	encounter_table = [0, 1, 4]
	encounter_levels = [3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 7]
	respawn_point = Vector3(-15, 1.01, -15)
	respawn_rotation = Vector3(0, -90, 0)
	l_name = "Floor 3"


func _on_ToFloor2_body_entered(body):
	emit_signal("go_to_floor", "res://Floor2.tscn", Vector3(-11, 1.01, -9), Vector3(0, -90, 0))


func _on_ToFloor4_body_entered(body):
	emit_signal("go_to_floor", "res://Floor4.tscn", Vector3(1, 1.01, 19), Vector3(0, 0, 0))
