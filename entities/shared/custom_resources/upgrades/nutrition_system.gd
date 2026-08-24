class_name NutritionSystem extends UpgradeAction

@export var nutrition_amount: float = 0.01
## If this is set to true, the nutrition will also be added if there is a
## plant in the pot, on default only empty pots will get nutrition
@export var is_auto_nutrition: bool = false

var _nutrition_system: NutritionRestoreSystem:
	get():
		if _nutrition_system == null:
			_nutrition_system = _systems.get_system("NutritionRestoreSystem")
		return _nutrition_system

func can_execute() -> bool:
	return _nutrition_system != null

func execute() -> bool:
	if is_auto_nutrition:
		_nutrition_system.auto_nutrition_restore_rate += nutrition_amount
		return true
	
	_nutrition_system.nutrition_restore_rate += nutrition_amount
	return true
