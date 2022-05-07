extends GridMap

var encounter_table
var encounter_levels
var respawn_point
var respawn_rotation
var l_name
var pickups = []

signal go_to_floor
signal heal_all

# Called when the node enters the scene tree for the first time.
func _ready():
	encounter_table = [0, 3]
	encounter_levels = [1, 1, 1, 2]
	respawn_point = Vector3(-11, 1.01, -9)
	respawn_rotation = Vector3(0, -90, 0)
	l_name = "Floor 1"

func _on_ToFloor2_body_entered(body):
	emit_signal("go_to_floor", "res://Floor2.tscn", Vector3(11, 1.01, 11), Vector3(0, 90, 0))
	#emit_signal("go_to_floor", "res://Floor5.tscn", Vector3(1, 1.01, -35), Vector3(0, 0, 0))

func get_item():
	pass

func _on_Heal_body_entered(body):
	emit_signal("heal_all")

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

