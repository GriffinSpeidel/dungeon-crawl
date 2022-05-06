extends GridMap

var encounter_table
var encounter_levels
var respawn_point
var respawn_rotation
var l_name

signal go_to_floor

# Called when the node enters the scene tree for the first time.
func _ready():
	encounter_table = [2, 3, [4, 5]]
	encounter_levels = [7, 8, 8, 9, 10]
	respawn_point = Vector3(13, 1.01, 13)
	respawn_rotation = Vector3(0, 90, 0)
	l_name = "Floor 4"


func _on_ToFloor3_body_entered(body):
	emit_signal("go_to_floor", "res://Floor3.tscn", Vector3(13, 1.01, 13), Vector3(0, 90, 0))

func _on_ToFloor5_body_entered(body):
	emit_signal("go_to_floor", "res://Floor5.tscn", Vector3(1, 1.01, -1), Vector3(0, 0, 0))

func save():
	var pickup_array = []
	for node in $ItemPickups.get_children():
		pickup_array.append([node.translation.x, node.translation.z, node.g_name, node.potency, node.variety, node.full])
	var node_dict = {
		"filename" : get_filename(),
		"pickup_array" : pickup_array
	}
	return node_dict

func load_pickups(pickup_array):
	for node in $ItemPickups.get_children():
		node.free()
	var pickup_res = load("res://ItemPickup.tscn")
	for pickup_data in pickup_array:
		var NewPickup = pickup_res.instance()
		NewPickup.translation = Vector3(pickup_data[0], 1, pickup_data[1])
		NewPickup.g_name = pickup_data[2]
		NewPickup.potency = pickup_data[3]
		NewPickup.variety = pickup_data[4]
		NewPickup.full = pickup_data[5]
		$ItemPickups.add_child(NewPickup)

