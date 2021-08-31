class_name PianoKey
extends AnimatedSprite

signal note_hit(type_of_hit)

const BAD_HIT = 0
const GOOD_HIT = 1
const PERFECT_HIT = 2

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
	elif event.is_action_released(action_name):
		play("default")


func handle_note_hit() -> void:
	var areas = $Area2D.get_overlapping_areas()
	if len(areas) > 0:
		var area = areas[0]
		var dist = abs(round(area.owner.position.y - position.y))
		if dist <= 15:
			consume_note(area, PERFECT_HIT)
		else:
			consume_note(area, GOOD_HIT)
		return
	play("miss")
	emit_signal("note_hit", BAD_HIT)


func consume_note(area, hit_type):
	play("hit")
	emit_signal("note_hit", hit_type)
	area.owner.queue_free()


