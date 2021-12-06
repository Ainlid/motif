extends Node
class_name Walker

const directions = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_history = []
var steps_since_turn = 0
var max_straight_steps = 4

func _init(start_position, new_borders):
	assert(new_borders.has_point(start_position))
	position = start_position
	step_history.append(position)
	borders = new_borders
	max_straight_steps = global_rng.rng.randi()%8+1

func _walk(steps):
	for step in steps:
		if global_rng.rng.randf() <= 0.25 or steps_since_turn >= max_straight_steps:
			_change_dir()
		if _step():
			#prevent overlap
			if !step_history.has(position):
				step_history.append(position)
		else:
			_change_dir()
	return step_history

func _step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	else:
		return false

func _change_dir():
	steps_since_turn = 0
	var dirs = directions.duplicate()
	dirs.erase(direction)
	dirs = global_rng._shuffle_array(dirs)
	direction = dirs.pop_front()
	while not borders.has_point(position + direction):
		direction = dirs.pop_front()
