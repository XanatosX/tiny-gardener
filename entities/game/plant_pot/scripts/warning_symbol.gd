class_name WarningSymbol extends Sprite3D

enum Severity
{
	NONE,
	WARNING,
	CRITICAL
}

@export var scale_multiplier: float = 1.3
@export var animation_time: float = 0.2

var _severity: Severity = Severity.NONE
var _tween_reference: Tween = null
var _initial_scale: Vector3

func _ready() -> void:
	_initial_scale = scale
	visible = false

func set_severity(severity: Severity) -> void:
	if severity == _severity:
		return
	_severity = severity
	_stop_running_tween()
	if _severity == Severity.NONE:
		visible = false
	if _severity == Severity.WARNING:
		visible = true
		scale = _initial_scale
	if _severity == Severity.CRITICAL:
		_animate_critical()

func _animate_critical() -> void:
	visible = true
	_tween_reference = create_tween()
	_tween_reference.set_loops(0)
	_tween_reference.tween_property(self, "scale", scale * scale_multiplier, animation_time)
	_tween_reference.tween_property(self, "scale", _initial_scale, animation_time)

func _stop_running_tween() -> void:
	if _tween_reference != null and _tween_reference.is_running():
		_tween_reference.stop()
		_tween_reference = null

