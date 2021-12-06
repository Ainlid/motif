extends Node

var rng_seed = ""
var rng = RandomNumberGenerator.new()

var characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

func _ready():
	randomize()
	_randomize_rng()

func _random_string(length):
	var rand_string: String
	var n_char = len(characters)
	for i in range(length):
		rand_string += characters[randi()%n_char]
	return rand_string

func _shuffle_array(array):
	var shuffled_array = [] 
	var index_array = range(array.size())
	for i in range(array.size()):
		var x = rng.randi()%index_array.size()
		shuffled_array.append(array[index_array[x]])
		index_array.remove(x)
	return shuffled_array

func _randomize_rng():
	rng_seed = _random_string(30)
	rng.seed = hash(rng_seed)

func _set_seed(new_seed):
	rng_seed = new_seed
	rng.seed = hash(rng_seed)
