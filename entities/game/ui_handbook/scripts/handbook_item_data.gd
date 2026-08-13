class_name HandbookItemData extends MarginContainer

signal set_icon(icon: Texture2D)
signal set_quality_icon(icon: Texture2D)

signal set_description(text: String)

var _item: Item

func _ready() -> void:
	_update_page()

func set_data(data: HandbookEntry) -> void:
	if data is ItemHandbookEntry:
		_item = data.item_reference.get_ref()
		_update_page()

func _update_page() -> void:
	if not is_node_ready() or _item == null:
		return
	set_icon.emit(_item.icon)
	set_quality_icon.emit(_item.get_quality_icon())
	set_description.emit(_item.get_long_description())