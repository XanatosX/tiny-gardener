class_name Pot extends Resource

signal plant_died()

@export var max_water_level: float = 100
@export var water_level: float = 0:
	set(value):
		_water_level = clampf(value, 0, max_water_level)
	get():
		return _water_level

@export var max_nutrition: float = 100
@export var max_nutrition_bonus_if_full: float = 2.0
@export var nutrition: float = 0:
	set(value):
		_nutrition = clampf(value, 0, max_nutrition)
	get():
		return _nutrition
@export var plant_data: PlantData = null:
	set(value):
		set_seed(value)
	get():
		return _plant_data

var natural_nutrition: float:
	get():
		return max_nutrition / 2

var _water_level: float = 0
var _nutrition: float = 0
var _plant_data: PlantData = null
var _plant: Plant = null

var _active: bool = false

func change_active_state(new_state: bool) -> void:
	_active = new_state

## Check if the pot is currently active in the game scene
func is_active() -> bool:
	return _active

func set_seed(plant_seed: PlantData) -> void:
	if plant_seed == null:
		clear_plant()
		return
	_plant_data = plant_seed
	_plant = Plant.new(_plant_data)

func clear_plant() -> void:
	_plant_data = null
	_plant = null

func get_plant() -> Plant:
	return _plant

func get_plant_health_percentage() -> float:
	if not has_plant():
		return 1
	return _plant.get_health() / _plant_data.initial_plant_health

func has_plant() -> bool:
	return get_plant() != null

func get_water_modifier() -> float:
	if _water_level > 0:
		return 1.0
	return 0.0

func get_nutrition_modifier() -> float:
	var percentage_filled: float = nutrition / max_nutrition
	return max_nutrition_bonus_if_full * percentage_filled

func growth_plant(growth: float) -> void:
	if not has_plant() or not _plant.is_alive():
		return
	if growth <= 0:
		_plant_dying()
		return
	
	var water_requirement: float = _plant_data.growing_water_requirement
	var nutrition_requirement: float = _plant_data.growing_nutrition_requirement
	if _plant.is_fully_grown():
		water_requirement = _plant_data.sustainable_water_requirement
		nutrition_requirement = _plant_data.sustainable_nutrition_requirement
	water_level -= water_requirement
	nutrition -= nutrition_requirement
	if not _plant.is_fully_grown():
		_plant.growth_plant(growth)

func add_fertilizer(fertilizer: Fertilizer) -> void:
	var max_allowed_fertilizer: float = max_nutrition
	if fertilizer.quality == Item.QUALITY.POOR:
		max_allowed_fertilizer = natural_nutrition
	
	var new_amount: float = clampf(nutrition + fertilizer.amount, 0, max_allowed_fertilizer)
	nutrition = new_amount

func add_nutrition(value: float) -> void:
	nutrition += value

func add_water(value: float) -> void:
	water_level += value

func _plant_dying() -> void:
	if not has_plant() or not _plant_data.plant_can_die:
		return
	_plant.take_damage()
	if not _plant.is_alive():
		plant_died.emit()

func plant_fully_grown() -> bool:
	return get_plant() != null and _plant.get_current_stage() == _plant_data.grow_stages - 1

func harvest() -> Dictionary[Item, int]:
	return plant_data.get_yield()

func get_saveable_pot() -> PotSave:
	return PotSave.from_pot(self)

func _restore_from_pot(new_pot: Pot) -> void:
	max_water_level = new_pot.max_water_level
	water_level = new_pot.water_level
	max_nutrition = new_pot.max_nutrition
	max_nutrition_bonus_if_full = new_pot.max_nutrition_bonus_if_full
	nutrition = new_pot.nutrition
	plant_data = new_pot.plant_data

func restore(saved_pot: PotSave) -> void:
	var replace_pot: Pot = saved_pot.get_pot()
	_restore_from_pot(replace_pot)
	if has_plant():
		_plant.update_from_saved_pot(saved_pot)
	
	