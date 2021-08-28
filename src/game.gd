extends Node2D

var PianoKey = load("res://PianoKey/PianoKey.tscn")
var Note = load("res://Note/Note.tscn")
var rng = RandomNumberGenerator.new()
var good_hits = 0
var bad_hits = 0

func _ready():
	rng.randomize()
	for i in range(8):
		var node = PianoKey.instance()
		$piano_bar.add_child(node)
		node.position.x = determine_position(i)
		node.set_action_name("play_note" + str(i+1))
		node.connect("good_hit", self, "_on_good_hit")
		node.connect("bad_hit", self, "_on_bad_hit")


func determine_position(note_index):
	return 100 + (100 * note_index) + (0 if note_index < 4 else 100)


var note_counter = 101
var next_end_count = 100

func _physics_process(_delta: float) -> void:
	note_counter += 1
	if note_counter > next_end_count:
		note_counter = 0
		next_end_count = rng.randi_range(10, 100)
		var r = rng.randi_range(0, 7)
		var node = Note.instance()
		$note_path.add_child(node)
		node.position.x = determine_position(r)


func _on_good_hit():
	good_hits += 1
	$Control/MarginContainer/Scores/Label_good_count.text = str(good_hits)
	
func _on_bad_hit():
	bad_hits += 1
	$Control/MarginContainer/Scores/Label_bad_count.text = str(bad_hits)
