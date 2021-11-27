extends Spatial

var size_x = 20
var size_z = 20
var borders
var steps_amount = 512

onready var gridmap = $gridmap

func _ready():
	randomize()
	size_x = 10 + randi()%10+1
	size_z = 10 + randi()%10+1
	borders = Rect2(1, 1, size_x - 2, size_z - 2)
	steps_amount = 200 + randi()%200+1
	_generate_maze()

func _generate_maze():
	for n_x in size_x:
		for n_z in size_z:
			#spawn walls
			gridmap.set_cell_item(n_x, 0, n_z, 0)
			#spawn floor
			gridmap.set_cell_item(n_x, -1, n_z, 1)
	var walker = Walker.new(Vector2(floor(size_x / 2), floor(size_z / 2)), borders)
	var map = walker._walk(steps_amount)
	walker.queue_free()
	for location in map:
		gridmap.set_cell_item(location.x, 0, location.y, -1)
