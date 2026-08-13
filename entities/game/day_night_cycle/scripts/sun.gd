class_name Sun extends DirectionalLight3D


var _last_target_degree: float = 0
var _wrapped: bool = false

var _last_time: float = 0

func _ready() -> void:
	_last_target_degree = rad_to_deg(rotation.x)
	_last_time = Time.get_unix_time_from_system()

func set_new_rotation(target_degree: float) -> void:
	_wrapped = target_degree < _last_target_degree
	var time_difference: float = Time.get_unix_time_from_system() - _last_time

	var tween: Tween = create_tween()
	tween.tween_method(_animation_method, _last_target_degree, target_degree, time_difference)
	

func _animation_method(value: float) -> void:
	if is_equal_approx(value, 360.0):
		value = 0.0
	value = absf(value)
		
	rotation.x = deg_to_rad(value)
	_last_target_degree = value
	_last_time = Time.get_unix_time_from_system()
