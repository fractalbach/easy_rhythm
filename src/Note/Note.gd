class_name Note
extends AnimatedSprite


var FALL_SPEED = 300 # 250
var DESTROY_Y_VALUE = 600


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	position.y = position.y + FALL_SPEED * delta
	if position.y > DESTROY_Y_VALUE:
		queue_free()
