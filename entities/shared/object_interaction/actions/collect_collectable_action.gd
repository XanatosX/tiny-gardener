class_name CollectCollectableAction extends Action


func controlled_node_has_valid_state(controlled_node: Node3D, systems: Systems) -> bool:
	var inventory_system: GameDataSystem = systems.get_system("GameDataSystem")
	if inventory_system == null:
		return false
	if not controlled_node is CollectableItemTool:
		return false

	var collectable: CollectableItemTool = controlled_node as CollectableItemTool
	var relevant_item: CollectableItem = collectable.item_data
	if relevant_item == null:
			return false
	if inventory_system.has_item(relevant_item):
		controlled_node.queue_free()
		return false
	return true

func can_execute(controlled_node: Node3D, _item: Item, _systems: Systems) -> bool:
	return controlled_node is CollectableItemTool

func execute(controlled_node: Node3D, _item: Item, systems: Systems) -> bool:
	if not controlled_node is CollectableItemTool:
		return false
	var collectable: CollectableItemTool = controlled_node as CollectableItemTool
	var relevant_item: CollectableItem = collectable.item_data
	if relevant_item == null:
		return false

	var inventory_system: GameDataSystem = systems.get_system("GameDataSystem")
	if inventory_system == null:
		return false

	var handbook_system: HandbookSystem = systems.get_system("HandbookSystem")
	if handbook_system == null:
		return false

	inventory_system.add_item(relevant_item, 1)
	handbook_system.open_handbook_entry_by_key(relevant_item.get_item_handbook_key())

	controlled_node.queue_free()
	return true