class_name PianoKey
extends AnimatedSprite

const BAD_HIT = 0
const GOOD_HIT = 1
const PERFECT_HIT = 2

const PERFECT_HIT_LAYER = 1
const GOOD_HIT_LAYER = 2

const BUFFER_PERFECT_HITS = 20
const BUFFER_GOOD_HITS = 50
const BUFFER_OK_HITS = 100


signal note_hit(type_of_hit)

var action_name = ""

func set_action_name(name):
	action_name = name

func _ready():
	play("default")

func _input(event: InputEvent) -> void:
	if action_name == "":
		return
	if event.is_action_pressed(action_name):
		handle_note_hit()
	if event.is_action_released(action_name):
		play("default")


func handle_note_hit() -> void:
	var areas = $Area2D.get_overlapping_areas()
	# print(areas)
	if len(areas) > 0:
		var area = areas[0]
		print(round(area.owner.position.y - position.y))
		
		
		if area.get_collision_layer_bit(PERFECT_HIT_LAYER):
			print("perfect hit")
			play("hit")
			emit_signal("note_hit", PERFECT_HIT)
			area.owner.queue_free()
			return
		elif area.get_collision_layer_bit(GOOD_HIT_LAYER):
			print("good hit")
			play("hit")
			emit_signal("note_hit", GOOD_HIT)
			area.owner.queue_free()
			return
	print("bad hit!")
	play("miss")
	emit_signal("note_hit", BAD_HIT)
