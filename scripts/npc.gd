extends Spatial

onready var icon = $mesh/icon
onready var tween = $mesh/icon/tween

var tween_time = 0.5

func _ready():
	icon.scale = Vector3.ZERO

func _body_entered(body):
	if body.is_in_group("player"):
		_show_icon()

func _body_exited(body):
	if body.is_in_group("player"):
		_hide_icon()

func _show_icon():
	tween.interpolate_property(icon, "scale",
	icon.scale, Vector3.ONE, tween_time,
	Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()

func _hide_icon():
	tween.interpolate_property(icon, "scale",
	icon.scale, Vector3.ZERO, tween_time,
	Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	tween.start()
