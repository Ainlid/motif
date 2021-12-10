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
var mat_prop = preload("res://resources/materials/prop.tres")

const floor_textures = [
	preload("res://resources/textures/floor/dirt.png"),
	preload("res://resources/textures/floor/grass.png")
	]
const wall_textures = [
	preload("res://resources/textures/wall/trees.png"),
	preload("res://resources/textures/wall/trees_blue.png"),
	preload("res://resources/textures/wall/trees_green.png")
	]
const ceiling_textures = [
	preload("res://resources/textures/ceiling/sky_blue.png"),
	preload("res://resources/textures/ceiling/sky_orange.png"),
	preload("res://resources/textures/ceiling/sky_gray.png"),
	preload("res://resources/textures/ceiling/sky_pink.png"),
	preload("res://resources/textures/ceiling/sky_green.png")
	]
const prop_textures = [
	preload("res://resources/textures/prop/bush.png"),
	preload("res://resources/textures/prop/bush_blue.png"),
	preload("res://resources/textures/prop/bush_red.png")
	]

const dots_icon = preload("res://resources/textures/icons/dots.png")

const icons = [
	preload("res://resources/textures/icons/smile.png"),
	preload("res://resources/textures/icons/frown.png"),
	preload("res://resources/textures/icons/neutral.png")
]
var icons_max = 8
var icons_picked = []

var portal = preload("res://nodes/portal.tscn")
var prop = preload("res://nodes/prop.tscn")
var npc = preload("res://nodes/npc.tscn")

onready var worldenv = $worldenv

func _ready():
	_set_textures()
	_set_up_env()
	_pick_icons()
	size_x = 10 + global_rng.rng.randi()%10+1
	size_z = 10 + global_rng.rng.randi()%10+1
	borders = Rect2(1, 1, size_x - 2, size_z - 2)
	steps_amount = 100 + global_rng.rng.randi()%300+1
	_generate_maze()

func _set_textures():
	mat_floor.albedo_texture = floor_textures[global_rng.rng.randi()%floor_textures.size()]
	mat_wall.albedo_texture = wall_textures[global_rng.rng.randi()%wall_textures.size()]
	mat_ceiling.albedo_texture = ceiling_textures[global_rng.rng.randi()%ceiling_textures.size()]
	mat_prop.albedo_texture = prop_textures[global_rng.rng.randi()%prop_textures.size()]

func _set_up_env():
	var env = worldenv.environment
	var bg_col = Color.from_hsv(global_rng.rng.randf(), global_rng.rng.randf_range(0.0, 0.4), global_rng.rng.randf_range(0.2, 0.8))
	env.background_color = bg_col
	env.fog_color = bg_col
	#env.ambient_light_color = Color.from_hsv(randf(), rand_range(0.0, 0.5), 1.0)

func _pick_icons():
	for n in icons_max:
		var id = global_rng.rng.randi()%icons.size()
		icons_picked.append(icons[id])

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
	var npc_chance = 0.0
	#chance to spawn NPCs at all
	if global_rng.rng.randf() > 0.5:
		npc_chance = global_rng.rng.randf_range(0.1, 0.5)
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
			if global_rng.rng.randf() < 0.25:
				if global_rng.rng.randf() > npc_chance:
					var new_prop = prop.instance()
					add_child(new_prop)
					new_prop.translation = world_pos + Vector3.DOWN * 4.0
				else:
					var new_npc = npc.instance()
					add_child(new_npc)
					new_npc.translation = world_pos + Vector3.DOWN * 4.0
					#chance to say something
					if global_rng.rng.randf() > 0.5:
						var icon_id = global_rng.rng.randi()%icons_max
						new_npc._set_icon(icons_picked[icon_id])
					else:
						new_npc._set_icon(dots_icon)
