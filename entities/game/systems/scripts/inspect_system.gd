class_name InspectSystem extends System

signal request_item_inspect(item: CollectableItem)

func inspect_collectable(item: CollectableItem) -> void:
	request_item_inspect.emit(item)