extends Node2D

onready var start_time = OS.get_ticks_msec()
onready var counter_time    = $Control/Info/Values/Counter_Time
onready var counter_perfect = $Control/Info/Values/Counter_Perfect
onready var counter_good    = $Control/Info/Values/Counter_Good
onready var counter_bad     = $Control/Info/Values/Counter_Bad

var PianoKey = load("res://PianoKey/PianoKey.tscn")
var Note = load("res://Note/Note.tscn")
var rng = RandomNumberGenerator.new()
var perfect_hits = 0
var good_hits = 0
var bad_hits = 0


func _ready():
	rng.randomize()
	for i in range(8):
		var node = PianoKey.instance()
		node.set_action_name("play_note" + str(i+1))
		node.connect("note_hit", self, "_on_note_hit")
		node.position = Vector2(determine_position(i), 500)
		$piano_bar.add_child(node)


func determine_position(note_index):
	return 100 + (100 * note_index) + (0 if note_index < 4 else 100)



# warning-ignore:unused_argument
func _process(delta: float) -> void:
	var milliseconds = OS.get_ticks_msec() - start_time
	var seconds = milliseconds / 1000
	var minutes = seconds / 60
	seconds = seconds - minutes*60
	# milliseconds = milliseconds - seconds*1000 - minutes*60000
	# counter_time.text = "%02d : %02d : %03d" % [minutes, seconds, milliseconds]
	counter_time.text = "%02d : %02d" % [minutes, seconds]


var note_counter = 101
var next_end_count = 100

func _physics_process(_delta: float) -> void:
	note_counter += 1
	if note_counter > next_end_count:
		note_counter = 0
		next_end_count = rng.randi_range(10, 80)
		var r = rng.randi_range(0, 7)
		var node = Note.instance()
		$note_path.add_child(node)
		node.position.x = determine_position(r)

func _on_note_hit(note_type: int):
	match note_type:
		0: _on_bad_hit()
		1: _on_good_hit()
		2: _on_perfect_hit()

func _on_good_hit():
	good_hits += 1
	counter_good.text = str(good_hits)
	
func _on_bad_hit():
	bad_hits += 1
	counter_bad.text = str(bad_hits)

func _on_perfect_hit():
	perfect_hits += 1 
	counter_perfect.text = str(perfect_hits)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit_game"):
		get_tree().quit()


