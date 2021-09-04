extends Node

var notes = [261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25]
var c4 = 261.63 # frequency (hz) of middle C (also called c4)
var multipliers = [1.0, 1.12, 1.26, 1.33, 1.5, 1.68, 1.89, 2.0]
var sample_hz = 22050.0 # Keep the number of samples to mix low, GDScript is not super fast.
var phase = 0.0
var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().
onready var player: AudioStreamPlayer = $AudioStreamPlayer


func _fill_buffer(pulse_hz: float):
	pulse_hz = pulse_hz
	var increment = pulse_hz / sample_hz
	var to_fill = playback.get_frames_available()
	while to_fill > 0:
		playback.push_frame(Vector2.ONE * sin(phase * TAU)) # Audio frames are stereo.
		phase = fmod(phase + increment, 1.0)
		to_fill -= 1


func _ready():
	player.stream.mix_rate = sample_hz # Setting mix rate is only possible before play().
	playback = player.get_stream_playback()


func enable(n: int):
	player.set_pitch_scale(multipliers[n-1])
	# player.volume_db = -( multipliers[n-1] - 1 )
	# var hz: float = float(notes[n-1])
	_fill_buffer(440.0)
	player.play()


func disable():
	pass
