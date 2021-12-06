extends Sprite

func _ready():
	modulate = Color.from_hsv(global_rng.rng.randf(), global_rng.rng.randf_range(0.5, 1.0), global_rng.rng.randf_range(0.2, 1.0))
	#modulate.a = 0.5
