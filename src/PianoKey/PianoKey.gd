extends AnimatedSprite

signal good_hit()
signal bad_hit()

var action_name = ""

func set_action_name(name):
	action_name = name


func _ready():
	play("default")


func _input(event):
	if event.is_action_pressed(action_name):
		var areas = $Area2D.get_overlapping_areas()
		if len(areas) > 1:
			push_warning("Multiple notes have been hit at the same time.")
		if len(areas) > 0:
			play("hit")
			emit_signal("good_hit")
		else:
			play("miss")
			emit_signal("bad_hit")
		for area in areas:
			area.owner.queue_free()
	
	if event.is_action_released(action_name):
		play("default")

