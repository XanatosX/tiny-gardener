## A label which will show the text only for the animation time, after that it will fade out
class_name TimedLabel extends Label

@export var animation_time: float = 0.4
@export var value_template: String = "%s"

func set_value(value: float) -> void:
	var prefix: String = ""
	if value > 0:
		prefix = "+"
	else:
		prefix = "-"
	text = value_template % [prefix, value]
	visible = true
	modulate = Color.WHITE
	await get_tree().create_timer(animation_time).timeout
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), animation_time)