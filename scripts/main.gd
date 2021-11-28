extends Spatial

var size_x = 20
var size_z = 20
var borders
var steps_amount = 512

onready var gridmap = $gridmap

var player = preload("res://nodes/player.tscn")

var tile_mats = [preload("res://resources/materials/floor.tres"),
preload("res://resources/materials/wall.tres"),
preload("res://resources/materials/ceiling.tres")]

onready var worldenv = $worldenv

func _ready():
	randomize()
	_generate_mats()
	_set_up_env()
	size_x = 10 + randi()%10+1
	size_z = 10 + randi()%10+1
	borders = Rect2(1, 1, size_x - 2, size_z - 2)
	steps_amount = 200 + randi()%200+1
	_generate_maze()

func _generate_mats():
	for tile_mat in tile_mats:
		var col1 = Color.from_hsv(randf(), rand_range(0.2, 0.8), rand_range(0.2, 0.8))
		tile_mat.set_shader_param("color1", col1)
		var col2 = Color.from_hsv(randf(), rand_range(0.2, 0.8), rand_range(0.2, 0.8))
		tile_mat.set_shader_param("color2", col2)
		var noise_tex = NoiseTexture.new()
		noise_tex.seamless = true
		noise_tex.height = 32
		noise_tex.width = 32
		#enable mipmapping and repeating
		noise_tex.set_flags(Texture.FLAG_MIPMAPS + Texture.FLAG_REPEAT)
		var noise = OpenSimplexNoise.new()
		noise.octaves = 1 + randi()%3
		noise.period = rand_range(8.0, 16.0)
		noise.seed = randi()
		noise_tex.noise = noise
		tile_mat.set_shader_param("noise", noise_tex)

func _set_up_env():
	var env = worldenv.environment
	var bg_col = Color.from_hsv(randf(), rand_range(0.2, 0.8), rand_range(0.2, 0.8))
	env.background_color = bg_col
	env.fog_color = bg_col

func _generate_maze():
	for n_x in size_x:
		for n_z in size_z:
			#spawn walls
			gridmap.set_cell_item(n_x, 0, n_z, 0)
			#spawn floor
			gridmap.set_cell_item(n_x, -1, n_z, 1)
			#spawn ceiling
			gridmap.set_cell_item(n_x, 1, n_z, 2)
	var walker = Walker.new(Vector2(floor(size_x / 2), floor(size_z / 2)), borders)
	var map = walker._walk(steps_amount)
	walker.queue_free()
	var loc_id = 0
	for location in map:
		if loc_id == 0:
			var new_player = player.instance()
			add_child(new_player)
			new_player.translation = gridmap.map_to_world(location.x, 0, location.y)
		loc_id += 1
		gridmap.set_cell_item(location.x, 0, location.y, -1)
