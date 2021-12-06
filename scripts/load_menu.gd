extends Control

onready var diary = $dream_diary
onready var seed_prompt = $seed_prompt

func _show_menu():
	diary._reset_list()
	show()

func _back_pressed():
	hide()

func _paste_pressed():
	seed_prompt.text = OS.get_clipboard()

func _load_pressed():
	global_rng._set_seed(seed_prompt.text)
	fader._fade_start(fader.dream_path)

func _random_pressed():
	seed_prompt.text = global_rng._random_string(30)
