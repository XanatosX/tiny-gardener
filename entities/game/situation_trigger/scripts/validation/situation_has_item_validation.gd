## Check if there are more items in the inventory than the min amount
class_name SituationHasItemValidation extends SituationValidation

@export var item: Item
@export var min_amount: int = 1
## Instead of checking if there are equal or more items as the min amount it will check if there are less items found
@export var invert: bool = false

func is_valid(systems: Systems) -> bool:
	var game_data_system: GameDataSystem = systems.get_system("GameDataSystem")
	var result: bool = game_data_system.get_item_count(item) >= min_amount
	if invert:
		return not result
	return result
