class_name InspectCollectableItemAction extends Action

func _init() -> void:
	type = Action.Type.Inspect

func controlled_node_has_valid_state(controlled_node: Node3D, _systems: Systems) -> bool:
	if not controlled_node is Conditional3DObject:
		return false
	return controlled_node.visible

func can_execute(controlled_node: Node3D, _item: Item, systems: Systems) -> bool:
	if not controlled_node.visible:
		return false
	if _get_inspect_system(systems) == null:
		return false
	if not controlled_node is Conditional3DObject:
		return false
	return true

func execute(controlled_node: Node3D, _item: Item, systems: Systems) -> bool:
	var inspect_system: InspectSystem = _get_inspect_system(systems)
	if inspect_system == null:
		return false
	if controlled_node is Conditional3DObject:
		inspect_system.inspect_collectable(controlled_node.item_data)
		return true
	return false

func _get_inspect_system(systems: Systems) -> InspectSystem:
	return systems.get_system("InspectSystem")