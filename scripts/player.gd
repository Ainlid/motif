extends KinematicBody

export var playable = true
export var gravity = -30.0
export var walk_speed = 8.0
export var turn_speed = 2.0
export var fall_limit = -100.0

var pivot

var dir = Vector3.ZERO
var velocity = Vector3.ZERO

onready var anim = $pivot/camera/animplayer

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
	#headbob
	if dir != Vector3.ZERO:
		anim.play("headbob")
	var target_vel = dir * walk_speed
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
