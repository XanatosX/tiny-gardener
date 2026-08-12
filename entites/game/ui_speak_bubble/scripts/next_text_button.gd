class_name NextTextButton extends TextureButton

@export var animate_in_time: float = 0.5
@export var animate_out_time: float = 0.1
@export var animation_loop_time: float = 0.7

var _initial_modulate: Color

func _init() -> void:
	visible = false

func _ready() -> void:
	_initial_modulate = modulate
	var tween: Tween = create_tween()
	tween.set_loops(0)
	tween.tween_property(self, "offset_transform_position", Vector2(-5, 0), animation_loop_time)
	tween.tween_property(self, "offset_transform_position", Vector2(5, 0), animation_loop_time)

func display_button() -> void:
	if visible:
		return
	modulate = _initial_modulate
	modulate.a = 0
	visible = true
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", _initial_modulate, animate_in_time)
	tween.finished.connect(func() -> void: disabled = false)

func hide_button() -> void:
	if not visible:
		return
	modulate = _initial_modulate
	disabled = true
	
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate", _initial_modulate, animate_out_time)
	tween.finished.connect(func() -> void: visible = false)
	
