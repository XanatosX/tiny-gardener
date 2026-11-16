class_name Sun extends DirectionalLight3D

@export var day_night_color: Gradient = null
@export var sun_energy: Curve = null

var _last_target_degree: float = 0
var _wrapped: bool = false

var _last_time: float = 0

func _ready() -> void:
	assert(day_night_color != null, "Missing day night gradient")
	assert(sun_energy != null, "Missing sun energy")
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

	var day_progress: float = value / 360.0
	light_color = day_night_color.sample(day_progress)
	light_energy = sun_energy.sample(day_progress)
		
	rotation.x = deg_to_rad(value)
	_last_target_degree = value
	_last_time = Time.get_unix_time_from_system()
