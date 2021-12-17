extends Spatial

onready var message = $message
onready var hbox = $message/centerbox/panelbox/hbox
onready var tween = $message/tween
var tween_time = 0.3

const glyphs = [
	preload("res://resources/textures/glyphs/square.png"),
	preload("res://resources/textures/glyphs/circle.png"),
	preload("res://resources/textures/glyphs/triangle.png"),
	preload("res://resources/textures/glyphs/star.png"),
	preload("res://resources/textures/glyphs/semicircle.png"),
	preload("res://resources/textures/glyphs/line.png"),
	preload("res://resources/textures/glyphs/line_diagonal.png"),
	preload("res://resources/textures/glyphs/cross.png"),
	preload("res://resources/textures/glyphs/plus.png"),
	preload("res://resources/textures/glyphs/diamond.png"),
	preload("res://resources/textures/glyphs/angle.png")
]

var min_length = 2
var max_length = 8

func _ready():
	message.modulate.a = 0.0
	var message_length = global_rng.rng.randi_range(min_length, max_length)
	_make_message(message_length)

func _make_message(length):
	var sprite_size = 64.0
	var sprite_margin = 16.0
	for n in length:
		var new_control = Control.new()
		hbox.add_child(new_control)
		new_control.rect_min_size.x = sprite_size + sprite_margin
		new_control.rect_min_size.y = sprite_size + sprite_margin
		if global_rng.rng.randf() > 0.25 or n == 0 or n + 1 == length:
			var new_sprite = Sprite.new()
			new_control.add_child(new_sprite)
			new_sprite.texture = glyphs[global_rng.rng.randi()%glyphs.size()]
			new_sprite.position.x = (sprite_size + sprite_margin) / 2.0
			new_sprite.position.y = (sprite_size + sprite_margin) / 2.0
			new_sprite.scale *= 0.5
			new_sprite.rotation = global_rng.rng.randi()%4 * PI / 2.0

func _body_entered(body):
	if body.is_in_group("player"):
		_show_icon()

func _body_exited(body):
	if body.is_in_group("player"):
		_hide_icon()

func _show_icon():
	tween.interpolate_property(message, "modulate",
	message.modulate, Color.white, tween_time,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _hide_icon():
	tween.interpolate_property(message, "modulate",
	message.modulate, Color(1.0, 1.0, 1.0, 0.0), tween_time,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
