class_name WaterAction extends Action

@export var water_amount: float = 10.0

func _init() -> void:
	type = Type.Water

var _game_data_system: GameDataSystem = null
func _get_game_data_system(systems: Systems) -> GameDataSystem:
	if _game_data_system == null:
		_game_data_system = systems.get_system("GameDataSystem")
	return _game_data_system

func controlled_node_has_valid_state(controlled_node: Node3D, systems: Systems) -> bool:
	var game_data_system: GameDataSystem = _get_game_data_system(systems)
	if game_data_system == null:
		return false
	for item: Item in game_data_system.get_items():
		if item is WaterCan:
			return item.has_water() and controlled_node is PotVisuals
	return false

func can_execute(controlled_node: Node3D, _item: Item, systems: Systems) -> bool:
	if controlled_node is not PotVisuals:
		return false
	var game_data_system: GameDataSystem = _get_game_data_system(systems)
	if game_data_system == null:
		return false
	for item: Item in game_data_system.get_items():
		if item is WaterCan:
			return item.has_water()
	return false

func execute(controlled_node: Node3D, _item: Item, systems: Systems) -> bool:
	var pot: PotVisuals = controlled_node as PotVisuals
	var water_can: WaterCan = _get_water_can(systems)
	if water_can == null or not water_can.has_water():
		return false
	var amount: float = water_can.use_water(water_amount)
	pot.pot.add_water(amount)
	return true

func _get_water_can(systems: Systems) -> WaterCan:
	var game_data_system: GameDataSystem = systems.get_system("GameDataSystem")
	for item: Item in game_data_system.get_items():
		if item is WaterCan:
			return item
	return null
