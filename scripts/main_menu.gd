extends Control

onready var play_button = $menu/play_button
onready var quit_timer = $menu/quit_button/timer

func _ready():
	randomize()
	play_button.grab_focus()

func _quit_pressed():
	fader._fade_out()
	quit_timer.start()

func _quit_game():
	get_tree().quit()
