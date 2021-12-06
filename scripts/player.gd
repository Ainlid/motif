extends KinematicBody

export var playable = true
export var gravity = -30.0
export var walk_speed = 8.0
export var fall_limit = -100.0
export var mouse_sensitivity = 0.0015

var pivot

var dir = Vector3.ZERO
var velocity = Vector3.ZERO

onready var anim = $pivot/camera/animplayer

func _ready():
	pivot = $pivot
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
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
		fader._next_dream()

func _unhandled_input(event):
	if event is InputEventMouseMotion and playable:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		pivot.rotation.x = clamp(pivot.rotation.x, -1.2, 1.2)
