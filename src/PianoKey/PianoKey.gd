class_name PianoKey
extends Node2D

signal note_hit(type_of_hit)

const BAD_HIT = 0
const GOOD_HIT = 1
const PERFECT_HIT = 2
onready var player = get_tree().get_root().get_node("game/MyAudioGen")
onready var sprite = $AnimatedSprite
onready var area2d = $AnimatedSprite/Area2D
var HitText = load("res://HitText/HitText.tscn")
var action_name = ""


func set_action_name(name):
	action_name = name


func _ready():
	sprite.play("default")


func _input(event: InputEvent) -> void:
	if action_name == "":
		return
	if event.is_action_pressed(action_name):
		handle_note_hit()
	elif event.is_action_released(action_name):
		handle_note_release()


func handle_note_release() -> void:
	sprite.play("default")


func handle_note_hit() -> void:
	var areas = area2d.get_overlapping_areas()
	if len(areas) > 0:
		var area = areas[0]
		var dist = abs(round(area.owner.position.y - position.y))
		if dist <= 15:
			consume_note(area, PERFECT_HIT)
			generate_hit_text("Perfect!", PERFECT_HIT)
		else:
			consume_note(area, GOOD_HIT)
			generate_hit_text("Good", GOOD_HIT)
		return
	sprite.play("miss")
	emit_signal("note_hit", BAD_HIT)
	generate_hit_text("WTF", BAD_HIT)


func consume_note(area:Area2D, hit_type:int) -> void:
	sprite.play("hit")
	emit_signal("note_hit", hit_type)
	area.owner.queue_free()


func generate_hit_text(text:String, hit_type:int) -> void:
	var h = HitText.instance()
	h.set_text(text)
	match hit_type:
		PERFECT_HIT: h.set_color(h.COLOR_PERFECT)
		GOOD_HIT: h.set_color(h.COLOR_GOOD)
		BAD_HIT: h.set_color(h.COLOR_BAD)
	add_child(h)
	h.run()

