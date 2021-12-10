extends Control

onready var play_button = $menu/play_button
onready var quit_timer = $menu/quit_button/timer

func _quit_pressed():
	fader._fade_out()
	quit_timer.start()

func _quit_game():
	get_tree().quit()
