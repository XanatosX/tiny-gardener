class_name HarvestAction extends Action

func _init() -> void:
	type = Action.Type.Harvest

func controlled_node_has_valid_state(controlled_node: Node3D, _systems: Systems) -> bool:
	var pot: PotVisuals = controlled_node as PotVisuals
	if pot == null:
		return false
	return pot.plant_fully_grown()

func can_execute(controlled_node: Node3D, item: Item, systems: Systems) -> bool:
	if systems == null or controlled_node is not PotVisuals or item != null:
		return false
	
	var game_data: GameDataSystem = systems.get_system("GameDataSystem")
	if game_data == null:
		return false

	var pot: PotVisuals = controlled_node as PotVisuals
	if pot.plant_alive() and pot.plant_fully_grown():
		return true
	return false

func execute(controlled_node: Node3D, _item: Item, systems: Systems) -> bool:
	var pot: PotVisuals = controlled_node as PotVisuals
	var game_data_system: GameDataSystem = systems.get_system("GameDataSystem")
	if pot == null or not pot.plant_fully_grown() or game_data_system == null:
		return false

	var harvest: Dictionary[Item, int] = pot.harvest_plant()
	game_data_system.add_multiple_items(harvest)

	return true