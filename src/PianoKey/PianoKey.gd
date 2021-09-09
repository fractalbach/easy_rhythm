class_name PianoKey
extends AnimatedSprite

signal note_hit(type_of_hit)

const BAD_HIT = 0
const GOOD_HIT = 1
const PERFECT_HIT = 2

var action_name = ""
var HitText = load("res://HitText/HitText.tscn")
onready var player = get_tree().get_root().get_node("game/MyAudioGen")


func set_action_name(name):
	action_name = name


func _ready():
	play("default")


func _input(event: InputEvent) -> void:
	if action_name == "":
		return
	if event.is_action_pressed(action_name):
		handle_note_hit()
		# player.enable(int(action_name.right(1)))
	elif event.is_action_released(action_name):
		play("default")
		# player.disable()


func handle_note_hit() -> void:
	var areas = $Area2D.get_overlapping_areas()
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
	play("miss")
	emit_signal("note_hit", BAD_HIT)
	generate_hit_text("WTF", BAD_HIT)


func consume_note(area, hit_type):
	play("hit")
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

