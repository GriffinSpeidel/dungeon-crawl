extends MeshInstance


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var arr = []
	arr.resize(mesh.ARRAY_MAX)
	
	var verts = PoolVector3Array()
	var color = PoolColorArray()
	
	verts.append(Vector3(-1, -1, -1))
	verts.append(Vector3(1, -1, -1))
	verts.append(Vector3(1, -1, 1))
	verts.append(Vector3(-1, -1, 1))
	verts.append(Vector3(-1, 0, -1))
	verts.append(Vector3(-1, 0, 1))
	
	color.append(Color(0.75, 0.75, 0.75))
	
	arr[Mesh.ARRAY_VERTEX] = verts
	arr[Mesh.ARRAY_COLOR] = color
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
