extends Node2D
class_name HitText

const COLOR_PERFECT = Color("0010ff")
const COLOR_GOOD = Color("3e9014")
const COLOR_BAD = Color("d20404")

func _ready() -> void:
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")

func set_text(text:String) -> void:
	$Label.text = text

func set_color(color:Color) -> void:
	$Label.set("custom_colors/font_color", color)

# The hit-text will run its animation, and then delete itself.
func run() -> void:
	$AnimationPlayer.play("TextMove")

func _on_animation_finished(anim_name: String) -> void:
	queue_free()
