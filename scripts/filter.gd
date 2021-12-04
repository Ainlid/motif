extends Sprite

func _ready():
	modulate = Color.from_hsv(randf(), rand_range(0.5, 1.0), rand_range(0.2, 1.0))
	#modulate.a = 0.5
