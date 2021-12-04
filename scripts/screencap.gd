extends Node

func _unhandled_input(event):
	if event.is_action_pressed("screenshot"):
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		var date = OS.get_datetime()
		var directory = Directory.new()
		var dir_path = OS.get_executable_path().get_base_dir() + "/screenshots"
		if !directory.dir_exists(dir_path):
			directory.make_dir(dir_path)
		var img_path = dir_path + "/mazedreams"
		img_path += str(date.day) + "_"
		img_path += str(date.month) + "_"
		img_path += str(date.year) + "_at_"
		img_path += str(date.hour) + "_"
		img_path += str(date.minute) + "_"
		img_path += str(date.second) + ".png"
		image.save_png(img_path)
