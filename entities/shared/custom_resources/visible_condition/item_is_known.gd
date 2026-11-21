class_name ItemIsKnown extends VisibleCondition

var _item_in_question: Item = null
var _game_data_system: GameDataSystem = null

func hook_up(systems: Systems, controlled_node: Conditional3DObject) -> void:
	_game_data_system = systems.get_system("GameDataSystem")
	if _game_data_system == null:
		push_error("No game data system found!")
		return
	_item_in_question = controlled_node.item_data
	_game_data_system.items_updated.connect(controlled_node.evaluate_visibility)
	return

func is_visible() -> bool:
	return _game_data_system.has_item(_item_in_question)

func destroy(controlled_node: Conditional3DObject) -> void:
	if _game_data_system.items_updated.is_connected(controlled_node.evaluate_visibility):
		_game_data_system.items_updated.disconnect(controlled_node.evaluate_visibility)