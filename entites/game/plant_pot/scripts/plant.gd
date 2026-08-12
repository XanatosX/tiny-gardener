class_name Plant extends RefCounted

var _plant_data_ref: PlantData
var _current_stage: int = 0
var _growth_point: float = 0.0

var _max_stages: int = 0
var _health: float = 0

func _init(data: PlantData) -> void:
	_max_stages = data.grow_stages - 1
	_plant_data_ref = data
	_health = data.initial_plant_health

func growth_plant(growth_points: float) -> void:
	if is_fully_grown():
		return
	_growth_point += growth_points
	if _growth_point >= _plant_data_ref.get_growth_point_for_stage(_current_stage):
		_growth_point -= _plant_data_ref.get_growth_point_for_stage(_current_stage)
		_current_stage += 1
		_current_stage = clampi(_current_stage, 0, _max_stages)

func get_growth_points() -> float:
	return _growth_point

func take_damage() -> void:
	_health -= 1

func get_health() -> float:
	return _health

func get_current_stage() -> int:
	return _current_stage

func is_fully_grown() -> bool:
	return _current_stage >= _max_stages

func is_alive() -> bool:
	return _health > 0

func update_from_saved_pot(pot: PotSave) -> void:
	_current_stage = pot.plant_stage
	_health = pot.plant_health
	_growth_point = pot.plant_growth_point