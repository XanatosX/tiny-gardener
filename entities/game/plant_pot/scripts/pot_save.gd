class_name PotSave extends Resource

@export var pot: Pot
@export var plant_health: float
@export var plant_growth_point: float
@export var plant_stage: int

static func from_pot(pot_data: Pot) -> PotSave:
	var pot_save: PotSave = PotSave.new()
	pot_save.pot = pot_data
	if not pot_save.pot.has_plant():
		return pot_save
	var plant: Plant = pot_save.pot.get_plant()
	pot_save.plant_health = plant.get_health()
	pot_save.plant_growth_point = plant.get_growth_points()
	pot_save.plant_stage = plant.get_current_stage()
	return pot_save

func get_pot() -> Pot:
	return pot
