extends Node

onready var menu = $menu
onready var menu_dialog = $menu/menu_dialog

func _ready():
	_unpause_game()

func _pause_game():
	get_tree().paused = true
	menu.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unpause_game():
	get_tree().paused = false
	menu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _reload():
	_unpause_game()
	fader._reload_scene()

func _menu_pressed():
	menu_dialog.popup_centered()

func _menu_confirmed():
	fader._fade_start(fader.menu_path)

func _input(event):
	if event.is_action_pressed("escape"):
		if !get_tree().paused:
			_pause_game()
		else:
			_unpause_game()
