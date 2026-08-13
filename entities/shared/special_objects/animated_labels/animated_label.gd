class_name AnimatedLabel extends Label

@export var animation_time: float = 0.4
@export var value_template: String = "%s"

var _real_value: float = 0
var _target_value: float = 0

var _animating: bool = false

func set_value(value: float) -> void:
	_target_value = value
	_animate()

func _animate() -> void:
	if _animating:
		return
	_animating = true
	var tween: Tween = create_tween()
	tween.tween_method(_increase_money, _real_value, _target_value, animation_time)
	tween.finished.connect(func() -> void: _animating = false)

func _increase_money(value: float) -> void:
	_real_value = value
	text = value_template % value
	
