class_name NutritionRestoreSystem extends TickDependentSystem

@export var nutrition_restore_rate: float = 0.01
@export var auto_nutrition_restore_rate: float = 0.0
@export var water_evaporate_rate: float = 0.01

var _tracked_pots: Array[Pot] = []

func _on_tick() -> void:
	for pot: Pot in _tracked_pots:
		if not pot.is_active():
			continue
		pot.add_water(-water_evaporate_rate)
		pot.add_nutrition(auto_nutrition_restore_rate)
		if pot.has_plant():
			continue
		pot.add_nutrition(nutrition_restore_rate)

func register_pot(pot: Pot) -> void:
	if _tracked_pots.find(pot) >= 0:
		return
	_tracked_pots.append(pot)