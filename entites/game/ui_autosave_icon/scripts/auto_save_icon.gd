class_name AutoSaveIcon extends TextureRect

@export var animation_in_out_time: float = 0.3
@export var animate_loop_time: float = 3
@export var min_show_time: float = 4

var _loop_tween: Tween = null
var _initial_modulate: Color= Color.WHITE

var _save_complete: bool = false
var _can_close: bool = false

func _ready() -> void:
	visible = false
	_initial_modulate = modulate
	modulate.a = 0
	offset_transform_enabled = true


func show_icon() -> void:
	_save_complete = false
	_can_close = false
	modulate = _initial_modulate
	modulate.a = 0
	visible = true

	if _loop_tween != null:
		_loop_tween.stop()
		_loop_tween = null
	_loop_tween = create_tween()
	_loop_tween.set_loops()
	_loop_tween.tween_property(self, "offset_transform_rotation", deg_to_rad(360), animate_loop_time)
	_loop_tween.step_finished.connect(_reset_loop)

	get_tree().create_timer(min_show_time).timeout.connect(_min_time_completed)

	var animate_in_tween: Tween = create_tween()
	animate_in_tween.tween_property(self, "modulate", _initial_modulate, animation_in_out_time)
	await animate_in_tween.finished

func _reset_loop(_step_count: int) -> void:
	offset_transform_rotation = fmod(offset_transform_rotation, TAU)
	print("round")

func hide_icon() -> void:
	_save_complete = true
	if not _can_close:
		return
	var animate_in_tween: Tween = create_tween()
	modulate = _initial_modulate
	var _new_modulate: Color = modulate
	_new_modulate.a = 0
	animate_in_tween.tween_property(self, "modulate", _new_modulate, animation_in_out_time)
	await animate_in_tween.finished

	if _loop_tween != null:
		_loop_tween.stop()
		_loop_tween = null
	visible = false
	offset_transform_rotation = 0
	
func _min_time_completed() -> void:
	_can_close = true
	if _save_complete:
		hide_icon()
