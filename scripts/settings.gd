extends Control

onready var bgm_slider = $menu/bgm_slider
onready var sfx_slider = $menu/sfx_slider

func _ready():
	bgm_slider.value = save_manager.config_data["volume"]["bgm"]
	sfx_slider.value = save_manager.config_data["volume"]["sfx"]
	hide()

func _settings_pressed():
	show()

func _ok_pressed():
	save_manager.config_data["volume"]["bgm"] = bgm_slider.value
	AudioServer.set_bus_volume_db(2, linear2db(bgm_slider.value / 100.0))
	save_manager.config_data["volume"]["sfx"] = sfx_slider.value
	AudioServer.set_bus_volume_db(1, linear2db(sfx_slider.value / 100.0))
	save_manager._save_data()
	hide()
