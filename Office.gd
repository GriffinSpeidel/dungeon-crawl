extends GridMap

signal pickup

var encounter_table
var encounter_levels
var respawn_point

func _ready():
	# var encounter_table = [0, 0, 0, 0, 0, 2, 2, 3, 3, 3,]
	encounter_table = [0]
	encounter_levels = [1, 1, 2, 2]
	respawn_point = Vector3(-3.268, 3.841, 1.01)

func _on_PickupTest_body_entered(body):
	emit_signal("pickup")
