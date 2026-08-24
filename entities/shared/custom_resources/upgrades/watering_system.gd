class_name WateringSystem extends UpgradeAction

@export var watering_amount: float = 0.05

var _nutrition_system: NutritionRestoreSystem:
	get():
		if _nutrition_system == null:
			_nutrition_system = _systems.get_system("NutritionRestoreSystem")
		return _nutrition_system

func can_execute() -> bool:
	return _nutrition_system != null

func execute() -> bool:
	_nutrition_system.water_evaporate_rate -= watering_amount
	return true
