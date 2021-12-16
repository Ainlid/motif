extends Node

onready var synths = [$low, $mid, $high]

var transposition = 0

var rng = RandomNumberGenerator.new()

const scale = [0, 2, 4, 6, 7, 9, 11]

func _ready():
	#29
	rng.seed = 29
	transposition = rng.randi()%12

func _make_seq():
	var seq = []
	for n in 8:
		var note = scale[rng.randi()%scale.size()]
		seq.append(note)
	return seq

func _play_music():
	var rate = 0.7
	for synth in synths:
		synth.rate = rate
		synth.sequence = _make_seq()
		synth.transposition = transposition
		synth._synth_start()
