extends GridMap

signal pickup

var encounter_table
var encounter_levels

func _ready():
	# var encounter_table = [0, 0, 0, 0, 0, 2, 2, 3, 3, 3,]
	encounter_table = [0]
	encounter_levels = [1, 1, 2, 2, 3]

func _on_PickupTest_body_entered(body):
	emit_signal("pickup")
