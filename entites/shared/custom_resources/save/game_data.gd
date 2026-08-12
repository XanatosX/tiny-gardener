## Class to store all the relevant game data
class_name GameData extends Resource

@export var money: float = 0
@export var items: Dictionary[Item, int] = {}

func add_item(new_item: Item, amount: int) -> void:
	assert(new_item != null, "Item should never be null")
		
	if _increase_item_amount(new_item, amount):
		return
	items.set(new_item, amount)

func _increase_item_amount(new_item: Item, amount: int) -> bool:
	for item: Item in items.keys():
		if item.is_identically(new_item):
			items.set(item, items.get(item) + amount)
			return true
	return false

func has_item(type: Item) -> bool:
	return get_item_amount(type) > 0

func get_item_amount(searched_item: Item) -> int:
	for item: Item in items:
		if item.is_identically(searched_item):
			return items.get(item)
	return 0

func get_items() -> Array[Item]:
	return items.keys()

func get_seeds() -> Array[PlantData]:
	var return_data: Array[PlantData] = []
	for item: Item in items:
		if item is PlantData:
			return_data.append(item)
	return return_data

func get_fertilizer() -> Array[Fertilizer]:
	var return_data: Array[Fertilizer]
	for item: Item in items:
		if item is Fertilizer:
			return_data.append(item)
	return return_data

func remove_item(type: Item, amount: int = 1) -> bool:
	if not has_item(type):
		return false
	for item: Item in items:
		if item.is_identically(type):
			if items.get(type) < amount:
				return false
			items.set(item, items.get(item) - amount)
			if get_item_amount(item) <= 0:
				items.erase(item)
	return true

func sell_item(item_to_sell: Item, amount: int) -> float:
	var income: float = 0
	for item: Item in items:
		if item.is_identically(item_to_sell):
			var max_amount: int = items.get(item)
			amount = clampi(amount, 0, max_amount)
			if amount == 0:
				return 0
			income += amount * item.get_sell_price()
			items.set(item, items.get(item) - amount)
			if items.get(item) == 0:
				items.erase(item)
	money += income
	return income

func sell_plant_drops() -> float:
	var income: float = 0
	for drop: Item in items:
		if drop is PlantDrop:
			income += sell_item(drop, items.get(drop))

	_clean_empty_items()
	money += income
	return income

func _clean_empty_items() -> void:
	for i: int in items.size():
		var index: int = items.size() - 1
		var item: Item = items.keys().get(index)
		if items.get(item) <= 0:
			items.erase(item)

func change_money(amount: float) -> bool:
	var result: float = money + amount
	if result < 0:
		return false
	money = result
	return true

func get_money() -> float:
	return money
	