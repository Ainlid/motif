extends Node

func _ready():
	OS.window_fullscreen = true

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
