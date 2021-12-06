extends Control

onready var bgm_slider = $tab_box/audio/bgm_slider
onready var sfx_slider = $tab_box/audio/sfx_slider
onready var mouse_sens_slider = $tab_box/game/mouse_sens_slider

onready var reset_config_dialog = $tab_box/data/reset_config_dialog
onready var reset_data_dialog = $tab_box/data/reset_data_dialog

func _ready():
	_update_values()
	hide()

func _show_menu():
	show()

func _ok_pressed():
	save_manager.config_data["volume"]["bgm"] = bgm_slider.value
	AudioServer.set_bus_volume_db(2, linear2db(bgm_slider.value / 100.0))
	save_manager.config_data["volume"]["sfx"] = sfx_slider.value
	AudioServer.set_bus_volume_db(1, linear2db(sfx_slider.value / 100.0))
	save_manager.config_data["game"]["mouse_sens"] = mouse_sens_slider.value
	save_manager._save_config()
	hide()

func _update_values():
	bgm_slider.value = save_manager.config_data["volume"]["bgm"]
	sfx_slider.value = save_manager.config_data["volume"]["sfx"]
	mouse_sens_slider.value = save_manager.config_data["game"]["mouse_sens"]

func _reset_config_pressed():
	reset_config_dialog.popup_centered()

func _reset_config_confirmed():
	save_manager._reset_config()
	_update_values()

func _reset_data_pressed():
	reset_data_dialog.popup_centered()

func _reset_data_confirmed():
	save_manager._reset_data()
