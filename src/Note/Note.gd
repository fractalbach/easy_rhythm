class_name Note
extends AnimatedSprite

var DESTROY_Y_VALUE = 600

func _process(delta: float) -> void:
	position.y = position.y + (Global.NOTE_SPEED * delta)
	if position.y > DESTROY_Y_VALUE:
		queue_free()
