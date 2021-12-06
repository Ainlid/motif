extends Node

onready var melody = $melody
onready var bass = $bass

var volume = -4

onready var timer = $timer
var tempo = 120.0
var speed_mod = 2.0

const major_scale = [0, 2, 4, 5, 7, 9, 11]
const minor_scale = [0, 2, 3, 5, 7, 8, 10]
const major_pent_scale = [0, 2, 4, 7, 9]
const minor_pent_scale = [0, 3, 5, 7, 10]

var scale = []
var transposition = 0

var chunk_amount = 8
var chunk_size = 8
var chunks = []

var sequence = []
var seq_size = 8

var curr_step = 0

func _ready():
	melody.volume_db = volume
	bass.volume_db = volume
	scale = _pick_scale()
	transposition = global_rng.rng.randi()%12
	sequence = _make_sequence()
	tempo = global_rng.rng.randf_range(100.0, 140.0) * speed_mod
	timer.wait_time = 60.0/tempo
	timer.start()

func _pick_scale():
	if global_rng.rng.randf() > 0.5:
		return major_scale
	else:
		return minor_scale

func _make_sequence():
	var seq = []
	for n in chunk_amount:
		chunks.append(_make_chunk())
	for n in seq_size:
		var id = global_rng.rng.randi()%chunk_amount
		seq += chunks[id]
	return seq

func _make_chunk():
	var chunk = []
	for n in chunk_size:
		var m_active
		if n%4 == 0:
			m_active = true
		else:
			m_active = global_rng.rng.randf() > 0.5
		var m_pitch = _note_to_pitch(scale[global_rng.rng.randi()%scale.size()] + transposition)
		var b_active = n%4 == 0
		var b_pitch = _note_to_pitch(scale[global_rng.rng.randi()%scale.size()] + transposition - 12.0 * 2)
		var step = {
			"m_active" : m_active,
			"m_pitch" : m_pitch,
			"b_active" : b_active,
			"b_pitch" : b_pitch,
		}
		chunk.append(step)
	return chunk

func _note_to_pitch(note):
	return pow(2.0, note/12.0)

func _timeout():
	#melody and bass
	var step = sequence[curr_step]
	if step["m_active"]:
		melody.pitch_scale = step["m_pitch"]
		melody.play()
	if step["b_active"]:
		bass.pitch_scale = step["b_pitch"]
		bass.play()
	#loop
	if curr_step + 1 < seq_size * chunk_size:
		curr_step += 1
	else:
		curr_step = 0
