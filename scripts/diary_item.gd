extends Node

onready var title_prompt = $content/title_prompt
onready var seed_prompt = $content/seed_prompt

onready var delete_dialog = $content/delete_dialog

func _set_info(dream_title, dream_seed):
	title_prompt.text = dream_title
	seed_prompt.text = dream_seed

func _get_title():
	return title_prompt.text

func _get_seed():
	return seed_prompt.text

func _copy_seed():
	OS.set_clipboard(seed_prompt.text)

func _edit_name_toggled(toggle_state):
	title_prompt.editable = toggle_state

func _edit_seed_toggled(toggle_state):
	seed_prompt.editable = toggle_state

func _delete_pressed():
	delete_dialog.popup_centered()

func _delete_confirmed():
	get_parent().remove_child(self)
	queue_free()
