class_name WaterCan extends Item

@export var water_level: float = 0
@export var max_storable_water: float = 200

func is_identically(item: Item) -> bool:
	if not item is WaterCan:
		return super(item)

	return item is WaterCan and item.quality == quality

func get_water() -> float:
	return water_level

func has_water() -> bool:
	return water_level > 0

func is_full() -> bool:
	return is_equal_approx(water_level, max_storable_water)

## Use a specific amount of water, the real used value is returned
func use_water(amount: float) -> float:
	water_level -= amount
	if water_level < 0:
		amount += water_level
		water_level = 0
	return amount
	
func fill_water(amount: float) -> void:
	water_level += amount
	water_level = clampf(amount, 0, max_storable_water)
