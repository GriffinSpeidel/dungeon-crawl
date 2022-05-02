extends GridMap

var encounter_table
var encounter_levels
var respawn_point
var respawn_rotation
var l_name

signal go_to_floor
signal start_boss

# Called when the node enters the scene tree for the first time.
func _ready():
	encounter_table = [4, 5]
	encounter_levels = [10, 11, 12]
	respawn_point = Vector3(1, 1.01, -1)
	respawn_rotation = Vector3(0, 0, 0)
	l_name = "Final Floor"


func _on_ToFloor4_body_entered(body):
	emit_signal("go_to_floor", "res://Floor4.tscn", Vector3(-3, 1.01, -17), Vector3(0, 180, 0))


func _on_StartBoss_body_entered(body):
	emit_signal("start_boss")
