extends AudioStreamPlayer

onready var timer = $timer
const adsr = preload("res://resources/audio/adsr.tres")

export var interval = 1.0
var rate = 1.0
export var volume = 1.0
export var transposition = 0
export var octave = 0
export var sequence = [0, 2, 4, 5, 7, 9, 11]

var is_playing = false
var step = 0

func _ready():
	volume_db = linear2db(0.0)
	play()

func _synth_start():
	is_playing = true
	timer.wait_time = interval / rate
	timer.start()
	_play_note()

func _note_to_pitch(note):
	return pow(2.0, note/12.0)

func _play_note():
	pitch_scale = _note_to_pitch(sequence[step] + transposition + octave * 12)
	if step < sequence.size() - 1:
		step += 1
	else:
		step = 0

func _process(delta):
	if is_playing:
		var fraction = 1.0 - timer.time_left/timer.wait_time
		volume_db = linear2db(adsr.interpolate(fraction) * volume)
