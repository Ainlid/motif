extends CanvasLayer

var path = "test"
const menu_path = "test"
const dream_path = "res://scenes/main.tscn"

var duration = 0.5
var rect
var tween
var timer

func _ready():
	rect = $rect
	tween = $tween
	timer = $timer
	timer.wait_time = duration

func _fade_start(var scene_path):
	path = scene_path
	var file = File.new()
	if file.file_exists(path):
		_fade_out()
		timer.start()
	else:
		_reload_scene()

func _fade_in():
	get_tree().paused = false
	tween.interpolate_property(rect, "color",
	rect.color, Color(0.0, 0.0, 0.0, 0.0), duration,
	Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()

func _fade_out():
	tween.interpolate_property(rect, "color",
	rect.color, Color(0.0, 0.0, 0.0, 1.0), duration,
	Tween.TRANS_EXPO, Tween.EASE_OUT)
	tween.start()

func _reload_scene():
	path = get_tree().get_current_scene().get_filename()
	_fade_out()
	timer.start()

func _change_scene():
	get_tree().change_scene(path)
	_fade_in()
