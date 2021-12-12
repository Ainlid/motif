extends Node

onready var synths = [$low, $mid, $high]

var transposition = 0

const scales = [
	#ionian
	[0, 2, 4, 5, 7, 9, 11],
	#dorian
	[0, 2, 3, 5, 7, 9, 10],
	#phrygian
	[0, 1, 3, 5, 7, 8, 10],
	#lydian
	[0, 2, 4, 6, 7, 9, 11],
	#mixolydian
	[0, 2, 4, 5, 7, 9, 10],
	#aeolian
	[0, 2, 3, 5, 7, 8, 10],
	#locrian
	[0, 1, 3, 5, 6, 8, 10]
]

var picked_scale = []

func _ready():
	picked_scale = _pick_scale()
	transposition = global_rng.rng.randi()%12

func _pick_scale():
	return scales[global_rng.rng.randi()%scales.size()]

func _make_seq():
	var seq = []
	for n in 8:
		var note = picked_scale[global_rng.rng.randi()%picked_scale.size()]
		seq.append(note)
	return seq

func _play_music():
	var rate = global_rng.rng.randf_range(0.5, 1.0)
	for synth in synths:
		synth.rate = rate
		synth.sequence = _make_seq()
		synth.transposition = transposition
		synth._synth_start()
