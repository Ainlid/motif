extends Spatial

var size_x = 20
var size_z = 20
var borders
var steps_amount = 100

onready var gridmap = $gridmap

var player = preload("res://nodes/player.tscn")

var mat_floor = preload("res://resources/materials/floor.tres")
var mat_wall = preload("res://resources/materials/wall.tres")
var mat_ceiling = preload("res://resources/materials/ceiling.tres")
var mat_portal = preload("res://resources/materials/portal.tres")
var mat_prop = preload("res://resources/materials/prop.tres")

const floor_textures = [
	preload("res://resources/textures/dirt_grass.png"),
	preload("res://resources/textures/planks.png"),
	preload("res://resources/textures/asphalt.png"),
	preload("res://resources/textures/grass_flowers.png"),
	preload("res://resources/textures/grass.png"),
	preload("res://resources/textures/ceramic_tiles.png")
	]
const wall_textures = [
	preload("res://resources/textures/tree_trunks.png"),
	preload("res://resources/textures/house_brick.png"),
	preload("res://resources/textures/house_modern.png"),
	preload("res://resources/textures/skyscraper.png"),
	preload("res://resources/textures/wall_log.png"),
	preload("res://resources/textures/wall_brick.png"),
	preload("res://resources/textures/hedge.png"),
	preload("res://resources/textures/fence_wood.png"),
	preload("res://resources/textures/fence_metal.png"),
	preload("res://resources/textures/wall_concrete.png"),
	preload("res://resources/textures/pipes.png"),
	preload("res://resources/textures/container.png"),
	preload("res://resources/textures/shop_shelf.png"),
	preload("res://resources/textures/wall_glass.png")
	]
const ceiling_textures = [
	preload("res://resources/textures/sky_day.png"),
	preload("res://resources/textures/sky_sunset.png"),
	preload("res://resources/textures/sky_night.png"),
	preload("res://resources/textures/sky_cloudy.png"),
	preload("res://resources/textures/ceiling_panel.png"),
	preload("res://resources/textures/ceiling_wood.png"),
	preload("res://resources/textures/water_surface.png"),
	preload("res://resources/textures/ceiling_glass.png")
	]
const portal_textures = [
	preload("res://resources/textures/door.png"),
	preload("res://resources/textures/ladder.png")
	]
const prop_textures = [
	preload("res://resources/textures/bush.png")
	]

var portal = preload("res://nodes/portal.tscn")
var prop = preload("res://nodes/prop.tscn")

onready var worldenv = $worldenv

func _ready():
	randomize()
	_set_textures()
	_set_up_env()
	size_x = 10 + randi()%10+1
	size_z = 10 + randi()%10+1
	borders = Rect2(1, 1, size_x - 2, size_z - 2)
	steps_amount = 100 + randi()%300+1
	_generate_maze()

func _set_textures():
	mat_floor.albedo_texture = floor_textures[randi()%floor_textures.size()]
	mat_wall.albedo_texture = wall_textures[randi()%wall_textures.size()]
	mat_ceiling.albedo_texture = ceiling_textures[randi()%ceiling_textures.size()]
	mat_portal.albedo_texture = portal_textures[randi()%portal_textures.size()]
	mat_prop.albedo_texture = prop_textures[randi()%prop_textures.size()]

func _set_up_env():
	var env = worldenv.environment
	var bg_col = Color.from_hsv(randf(), rand_range(0.0, 0.4), rand_range(0.2, 0.8))
	env.background_color = bg_col
	env.fog_color = bg_col
	env.ambient_light_color = Color.from_hsv(randf(), rand_range(0.0, 0.5), 1.0)

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
		loc_id += 1
		var world_pos = gridmap.map_to_world(location.x, 0, location.y)
		#erase a wall here
		gridmap.set_cell_item(location.x, 0, location.y, -1)
		if loc_id == 1:
			var new_player = player.instance()
			add_child(new_player)
			new_player.translation = world_pos + Vector3.DOWN * 2.0
		if loc_id == map.size():
			var new_portal = portal.instance()
			add_child(new_portal)
			new_portal.translation = world_pos + Vector3.DOWN * 4.0
		if loc_id > 1 and loc_id < map.size():
			if randf() < 0.25:
				var new_prop = prop.instance()
				add_child(new_prop)
				new_prop.translation = world_pos + Vector3.DOWN * 4.0
