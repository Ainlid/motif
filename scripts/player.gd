extends KinematicBody

export var playable = true
export var gravity = -30.0
export var walk_speed = 8.0
export var jump_speed = 10.0
export var turn_speed = 2.0
export var fall_limit = -100.0

var pivot

var dir = Vector3.ZERO
var velocity = Vector3.ZERO

func _ready():
	pivot = $pivot
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	#turning
	if Input.is_action_pressed("look_up"):
		pivot.rotate_x(turn_speed * delta)
	if Input.is_action_pressed("look_down"):
		pivot.rotate_x(-turn_speed * delta)
	pivot.rotation.x = clamp(pivot.rotation.x, -1.2, 1.2)
	if Input.is_action_pressed("look_left"):
		rotate_y(turn_speed * delta)
	if Input.is_action_pressed("look_right"):
		rotate_y(-turn_speed * delta)
	#walking
	dir = Vector3.ZERO
	var basis = global_transform.basis
	if Input.is_action_pressed("move_forward"):
		dir -= basis.z
	if Input.is_action_pressed("move_back"):
		dir += basis.z
	if Input.is_action_pressed("move_left"):
		dir -= basis.x
	if Input.is_action_pressed("move_right"):
		dir += basis.x
	dir = dir.normalized()
	#jumping
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
	var target_vel = dir * walk_speed
	#checking wall collision to prevent climbing steep slopes
	if !is_on_wall():
		velocity.x = target_vel.x
		velocity.z = target_vel.z
	velocity.y += gravity * delta
	if playable:
		velocity = move_and_slide(velocity, Vector3.UP, true)
	if translation.y < fall_limit:
		_restart()

func _restart():
	if playable:
		playable = false
		fader._reload_scene()
