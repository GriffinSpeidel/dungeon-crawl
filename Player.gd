extends KinematicBody

const MOVE_SPEED = 4
const GRAVITY = -0.5
const MAX_FALL_SPEED = -24.8
const MAX_SLOPE_ANGLE = 40
const ACCEL = 2
const DECEL = 2

var dir = Vector3()
var camera
var rotation_helper
var mouse_sensitivity = 0.2
var y_vel = 0
var steps_since_update

signal check_for_encounter
signal update_danger_level

func _ready():
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper
	steps_since_update = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input()

func process_input():
	var cam_xform = camera.get_global_transform()
	
	var move_vec = Vector3()
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_pressed("move_forward"):
			move_vec += -cam_xform.basis.z
		if Input.is_action_pressed("move_back"):
			move_vec += cam_xform.basis.z
		if Input.is_action_pressed("strafe_left"):
			move_vec += -cam_xform.basis.x
		if Input.is_action_pressed("strafe_right"):
			move_vec += cam_xform.basis.x
	
	move_vec.y = 0
	move_vec = move_vec.normalized() * MOVE_SPEED
	move_vec.y = y_vel
	move_and_slide(move_vec, Vector3(0, 1, 0), true, 4, deg2rad(MAX_SLOPE_ANGLE), false)
	steps_since_update += Vector2(move_vec[0], move_vec[2]).length_squared()
	
	if steps_since_update >= 500:
		steps_since_update = 0
		emit_signal("update_danger_level")
	
	var grounded = is_on_floor()
	y_vel += GRAVITY
	if grounded and y_vel <= 0:
		y_vel = -0.1
	if y_vel < MAX_FALL_SPEED:
		y_vel = MAX_FALL_SPEED

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -1))
		self.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))
		
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
