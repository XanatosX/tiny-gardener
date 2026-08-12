class_name ShopUi extends MarginContainer

@export var animation_time: float = 0.2

signal show_ui()
signal close_ui()
signal animation_done()

var _silent_close: bool = false

func animate_in() -> void:
	visible = true
	show_ui.emit()
	var tween: Tween = create_tween()
	tween.tween_property(self, "offset_transform_scale", Vector2.ONE, animation_time)
	tween.finished.connect(_trigger_animation_done)

func animate_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "offset_transform_scale", Vector2.ZERO, animation_time)
	tween.finished.connect(_hide_shop_ui)
	tween.finished.connect(_trigger_animation_done)

func silent_close() -> void:
	_silent_close = true
	animate_out()

func _hide_shop_ui() -> void:
	visible = false
	if _silent_close:
		_silent_close = false
		return
	close_ui.emit()

func _trigger_animation_done() -> void:
	animation_done.emit()