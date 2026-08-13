class_name FertilizeAction extends Action

func _init() -> void:
	type = Action.Type.Fertilize

func controlled_node_has_valid_state(controlled_node: Node3D, systems: Systems) -> bool:
	var pot: PotVisuals = controlled_node as PotVisuals
	var game_data: GameDataSystem = systems.get_system("GameDataSystem")
	if game_data == null or pot == null:
		return false
	return game_data.get_available_fertilizer().size() > 0

func can_execute(controlled_node: Node3D, item: Item, systems: Systems) -> bool:
	if item == null or systems == null or controlled_node is not PotVisuals:
		return false
	
	var game_data: GameDataSystem = systems.get_system("GameDataSystem")
	if game_data == null:
		return false
	
	return item is Fertilizer

func execute(controlled_node: Node3D, item: Item, systems: Systems) -> bool:
	var pot: PotVisuals = controlled_node as PotVisuals
	var game_data: GameDataSystem = systems.get_system("GameDataSystem")

	if pot == null or game_data == null:
		return false
	var fertilizer: Fertilizer = item as Fertilizer
	if item != null and game_data.use_item(item):
		pot.pot.add_fertilizer(fertilizer)

	return false