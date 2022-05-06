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
	encounter_levels = [11, 12, 12, 13]
	respawn_point = Vector3(1, 1.01, -1)
	respawn_rotation = Vector3(0, 0, 0)
	l_name = "Final Floor"


func _on_ToFloor4_body_entered(body):
	emit_signal("go_to_floor", "res://Floor4.tscn", Vector3(-3, 1.01, -17), Vector3(0, 180, 0))


func _on_StartBoss_body_entered(body):
	emit_signal("start_boss")

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
