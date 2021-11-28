extends Node

onready var menu = $menu
onready var resume_button = $menu/resume_button

func _ready():
	_unpause_game()

func _pause_game():
	get_tree().paused = true
	menu.show()
	resume_button.grab_focus()

func _unpause_game():
	get_tree().paused = false
	menu.hide()

func _reload():
	_unpause_game()
	fader._reload_scene()

func _main_menu():
	fader._fade_start(fader.menu_path)

func _process(delta):
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		_pause_game()
