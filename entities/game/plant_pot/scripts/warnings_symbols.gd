class_name PotWarningDisplay extends Node3D

signal water_state_changed(severity: WarningSymbol.Severity)
signal nutrition_state_changed(severity: WarningSymbol.Severity)
signal health_state_changed(severity: WarningSymbol.Severity)

@export var pot_visuals: PotVisuals

@export var warning_percentage: float = 0.25
@export var critical_percentage: float = 0.15

var _camera: Camera3D:
	get():
		if _camera == null:
			_camera = get_viewport().get_camera_3d()
		return _camera

var _pot_data: Pot:
	get():
		return pot_visuals.pot

func _ready() -> void:
	active_state_changed(pot_visuals.is_active())
	pot_visuals.active_state_changed.connect(active_state_changed)
	visible = true

func _process(_delta: float) -> void:
	assert(_camera != null, "Missing camera?")
	look_at(_camera.global_position)
	_calculate_water()
	_calculate_nutrition()
	_calculate_health()

func _get_severity_for(current_value: float, max_value: float) -> WarningSymbol.Severity:
	return _get_severity_for_percentage(current_value / max_value)

func _get_severity_for_percentage(percentage: float) -> WarningSymbol.Severity:
	if percentage <= critical_percentage:
		return WarningSymbol.Severity.CRITICAL
	if percentage <= warning_percentage:
		return WarningSymbol.Severity.WARNING

	return WarningSymbol.Severity.NONE
		

func _calculate_water() -> void:
	water_state_changed.emit(_get_severity_for(_pot_data.water_level, _pot_data.max_water_level))

func _calculate_nutrition() -> void:
	nutrition_state_changed.emit(_get_severity_for(_pot_data.nutrition, _pot_data.natural_nutrition))

func _calculate_health() -> void:
	health_state_changed.emit(_get_severity_for_percentage(_pot_data.get_plant_health_percentage()))

func active_state_changed(new_state: bool) -> void:
	if new_state:
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED
