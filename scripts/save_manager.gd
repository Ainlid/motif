extends Node

const config_path = "user://mazedreams.cfg"
var config_file = ConfigFile.new()

var default_config = {
	"volume" : {
		"bgm" : 100.0,
		"sfx" : 100.0
	},
	"game" : {
		"mouse_sens" : 15.0
	}
}

var config_data = default_config

const data_path = "user://mazedreams.dat"

var default_data = {
	"dreams" : {}
}

var game_data = default_data

func _ready():
	_load_config()
	_load_data()

func _save_config():
	for section in config_data.keys():
		for key in config_data[section].keys():
			config_file.set_value(section, key, config_data[section][key])
	config_file.save(config_path)

func _load_config():
	var error = config_file.load(config_path)
	if error == OK:
		for section in config_data.keys():
			for key in config_data[section].keys():
				var val = config_file.get_value(section,key)
				config_data[section][key] = val

func _save_data():
	var file = File.new()
	var error = file.open(data_path, File.WRITE)
	if error == OK:
		file.store_var(game_data)
		file.close()

func _load_data():
	var file = File.new()
	if file.file_exists(data_path):
		var error = file.open(data_path, File.READ)
		if error == OK:
			game_data = file.get_var()
			file.close()

func _reset_config():
	config_data = default_config
	_save_config()

func _reset_data():
	game_data = default_data
	_save_data()
