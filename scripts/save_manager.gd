extends Node

const config_path = "user://mazedreams.cfg"
var config_file = ConfigFile.new()

var config_data = {
	"volume" : {
		"bgm" : 100.0,
		"sfx" : 100.0
	}
}

func _ready():
	_load_config()

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
