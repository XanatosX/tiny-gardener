class_name PlantAction extends Action

func _init() -> void:
	type = Action.Type.Plant

func controlled_node_has_valid_state(controlled_node: Node3D, systems: Systems) -> bool:
	var pot: PotVisuals = controlled_node as PotVisuals
	var game_data: GameDataSystem = systems.get_system("GameDataSystem")
	if game_data == null:
		return false
	if game_data.get_available_seeds().size() == 0:
		return false
	if pot == null:
		return false
	return not pot.plant_alive()

func can_execute(controlled_node: Node3D, item: Item, systems: Systems) -> bool:
	if item == null or systems == null or controlled_node is not PotVisuals:
		return false
	
	var game_data: GameDataSystem = systems.get_system("GameDataSystem")
	if game_data == null:
		return false
	
	var pot: PotVisuals = controlled_node as PotVisuals
	if pot.plant_alive():
		return false
	if item is PlantData:
		return game_data.has_item(item)

	return false

func execute(controlled_node: Node3D, item: Item, systems: Systems) -> bool:
	var pot: PotVisuals = controlled_node as PotVisuals
	var plant: PlantData = item as PlantData
	var game_data: GameDataSystem = systems.get_system("GameDataSystem")
	if pot == null or plant == null or game_data == null:
		return false
	if game_data.use_item(plant):
		pot.add_plant(plant)
		return true
	return false
