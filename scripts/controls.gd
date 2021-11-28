extends Button

onready var popup = $popup

func _pressed():
	popup.popup_centered()
