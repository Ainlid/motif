extends Control

onready var diary = $dream_diary

onready var seed_label = $seed_label
onready var title_prompt = $title_prompt

func _ready():
	hide()
	seed_label.text = global_rng.rng_seed

func _show_menu():
	diary._reset_list()
	show()

func _add_pressed():
	diary._add_item(title_prompt.text, seed_label.text)

func _back_pressed():
	hide()
