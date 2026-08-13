class_name FillWaterCanAction extends Action

@export var fill_amount: float = 1000.0

var _game_data_system: GameDataSystem = null
func _get_game_data_system(systems: Systems) -> GameDataSystem:
	if _game_data_system == null:
		_game_data_system = systems.get_system("GameDataSystem")
	return _game_data_system

func controlled_node_has_valid_state(_controlled_node: Node3D, systems: Systems) -> bool:
	var game_data_system: GameDataSystem = _get_game_data_system(systems)
	if game_data_system == null:
		return false
	for item: Item in game_data_system.get_items():
		if item is WaterCan:
			return not item.is_full()
	return false

func can_execute(controlled_node: Node3D, _item: Item, systems: Systems) -> bool:
	return controlled_node_has_valid_state(controlled_node, systems)

func execute(_controlled_node: Node3D, _item: Item, systems: Systems) -> bool:
	var water_can: WaterCan = _get_water_can(systems)
	if water_can == null or water_can.is_full():
		return false
	var water_level: float = water_can.get_water()
	water_can.fill_water(fill_amount)
	return water_can.get_water() > water_level

func _get_water_can(systems: Systems) -> WaterCan:
	var game_data_system: GameDataSystem = systems.get_system("GameDataSystem")
	for item: Item in game_data_system.get_items():
		if item is WaterCan:
			return item
	return null