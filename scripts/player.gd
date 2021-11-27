extends KinematicBody

export var playable = true
export var gravity = -30.0
export var walk_speed = 8.0
export var run_speed = 16.0
export var jump_speed = 10.0
export var mouse_sensitivity = 0.002
export var fall_limit = -100.0

var pivot

var dir = Vector3.ZERO
var velocity = Vector3.ZERO

func _ready():
	pivot = $pivot
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
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
	var speed = walk_speed
	if is_on_floor():
		if Input.is_action_pressed("run"):
			speed = run_speed
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_speed
	var target_vel = dir * speed
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

func _unhandled_input(event):
	if event is InputEventMouseMotion and playable:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		pivot.rotation.x = clamp(pivot.rotation.x, -1.2, 1.2)
