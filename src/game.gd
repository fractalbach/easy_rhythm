extends Node2D

onready var counter_time: Label    = $Control/Info/Values/Counter_Time
onready var counter_perfect: Label = $Control/Info/Values/Counter_Perfect
onready var counter_good: Label    = $Control/Info/Values/Counter_Good
onready var counter_bad: Label     = $Control/Info/Values/Counter_Bad
onready var song_loader: SongLoader = $SongLoader
onready var piano_bar: Node = $piano_bar
onready var note_path: Node = $note_path

var PianoKey: Resource = load("res://PianoKey/PianoKey.tscn")
var Note: Resource = load("res://Note/Note.tscn")
var start_time: int = OS.get_ticks_msec()
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var perfect_hits: int = 0
var good_hits: int = 0
var bad_hits: int = 0
var bad_apple_index: int = 0
var music_has_started: bool = false

func _ready() -> void:
	rng.randomize()
	for i in range(8):
		var node:PianoKey = PianoKey.instance()
		node.set_action_name("play_note" + str(i+1))
		node.connect("note_hit", self, "_on_note_hit")
		node.position = Vector2(determine_position(i), 500)
		piano_bar.add_child(node)


func determine_position(note_index:int) -> int:
	return 100 + (100 * note_index) + (0 if note_index < 4 else 100)





func _process(_delta: float) -> void:
	var milliseconds = OS.get_ticks_msec() - start_time
	var seconds = milliseconds / 1000
	var minutes = seconds / 60
	seconds = seconds - minutes*60
	counter_time.text = "%02d : %02d" % [minutes, seconds]
	generate_bad_apple_note(float(milliseconds) / 1000.0 - 28)


func generate_bad_apple_note(current_seconds:float) -> void:
	if len(song_loader.data) <= bad_apple_index:
		return
	var entry = song_loader.data[bad_apple_index]
	if current_seconds >= entry[0]:
		create_note_on_track(entry[1])
		bad_apple_index += 1
		if bad_apple_index % 100 == 0:
			print("bad_apple: ", bad_apple_index)



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
	if (
		((event is InputEventScreenTouch) or (event is InputEventMouseButton))
		and event.is_pressed()
	):
		var k:int = floor((event.position.x - 50) / 100)
		var n:int = -1
		match k:
			0,1,2,3: n = k
			5,6,7,8: n = k - 1
			_:       return
		piano_bar.get_children()[n].handle_note_hit()


func mouse_position_to_piano_key_index(mousex:int) -> int:
	return 0

# Random Note Generator:

var note_counter = 101
var next_end_count = 100

func generate_random_note() -> void:
	note_counter += 1
	if note_counter > next_end_count:
		note_counter = 0
		next_end_count = rng.randi_range(10, 80)
		var r = rng.randi_range(0, 7)
		create_note_on_track(r)

func create_note_on_track(track_num:int) -> void:
	var note = Note.instance()
	note.position.x = determine_position(track_num)
	note.position.y = -100
	note_path.add_child(note)
