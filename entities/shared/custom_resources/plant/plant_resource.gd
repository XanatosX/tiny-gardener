class_name PlantData extends Item

enum Type
{
	NONE,
	CORN,
	ROSE,
}

@export var type: Type = Type.NONE
@export var texture: Texture = null
@export_group("Yield")
@export var plant_yield: Array[PlantDropConfiguration] = []
@export var spin_amount: Dictionary[Item.QUALITY, int] = {
	QUALITY.POOR: 2,
	QUALITY.STANDARD: 3,
	QUALITY.PREMIUM: 2
}
@export var quality_curve: Curve
@export_group("Growth")
@export var grow_stages: int = 1
@export var growth_points_per_stage: float = 10.0
@export_group("Health")
@export var plant_can_die: bool = true
@export var initial_plant_health: float = 100.0
## How much more nutrition this plant is using if the health is not full
@export var heal_nutrition_penalty: float = 1
## How much more water this plant is using if the health is not full
@export var heal_water_penalty: float = 1
@export_group("Resource requirements")
@export var growing_water_requirement: float = 1.0
@export var growing_nutrition_requirement: float = 1.0
@export var sustainable_water_requirement: float = 0.2
@export var sustainable_nutrition_requirement: float = 0.2

func get_growth_point_for_stage(_stage: int) -> float:
	return growth_points_per_stage

func get_yield() -> Dictionary[Item, int]:
	var return_data: Dictionary[Item, int] = {}
	for drop: PlantDropConfiguration in plant_yield:
		var random: int = randi_range(0, 100)
		var already_added: bool = false
		if random > drop.probability_percentage:
			continue
		for item_count: int in _get_drop_amount(drop.min_yield, drop.max_yield):
			var item: PlantDrop = drop.plant_drop.duplicate_deep()
			var drop_quality: Item.QUALITY = get_drop_quality()
			item.quality = drop_quality
			for stored_item: PlantDrop in return_data.keys():
				if stored_item.is_identically(item):
					return_data.set(stored_item, return_data.get(stored_item) + 1)
					already_added = true
					break
			if already_added:
				continue
			return_data.set(item, 1)
	return return_data

func _get_drop_amount(min_yield: int, max_yield: int) -> int:
	var return_value: int = 0
	var spins: int = spin_amount.get(quality)
	var results: Array[int] = []
	for spin: int in spins:
		results.append(randi_range(min_yield, max_yield))

	match quality:
		QUALITY.POOR:
			return_value = results.min()
		QUALITY.STANDARD:
			var size: int = results.size()
			return_value = ceili(results.reduce(func(a: int, b:int ) -> int: return a + b, 0) / size)
		QUALITY.PREMIUM:
			return_value = results.max()
	
	return clampi(return_value, min_yield, max_yield)

func get_drop_quality() -> Item.QUALITY:
	var value_to_request: float = randf_range(quality_curve.min_value, quality_curve.max_value)
	var value: float = quality_curve.sample(value_to_request) + _plant_quality_addition()
	
	if value > 0.85:
		return Item.QUALITY.PREMIUM
	if value > 0.5:
		return Item.QUALITY.STANDARD
	return Item.QUALITY.POOR

func _plant_quality_addition() -> float:
	match quality:
		Item.QUALITY.POOR:
			return -0.14
		Item.QUALITY.STANDARD:
			return 0
		Item.QUALITY.PREMIUM:
			return 0.25
	return 0