extends Node

onready var menu = $menu
onready var resume_button = $menu/resume_button

func _ready():
	_unpause_game()

func _input(event):
	if event.is_action_pressed("escape"):
		if !get_tree().paused:
			_pause_game()
		else:
			_unpause_game()

func _pause_game():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	menu.show()
	resume_button.grab_focus()

func _unpause_game():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	menu.hide()

func _reload():
	_unpause_game()
	fader._reload_scene()

func _main_menu():
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	fader._fade_start(fader.menu_path)
