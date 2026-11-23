class_name Ui3DObjectInspectScreen extends Control

signal inspect_item_selected(item: CollectableItem)
signal inspect_requested()
signal change_item_name(name: String)
signal change_handbook_link(identifier: String)

func _ready() -> void:
	hidden.connect(_hiding)
	hide()

func inspect_object(item: CollectableItem) -> void:
	if item == null or item.representation == null:
		return
	change_item_name.emit(item.get_display_name())
	change_handbook_link.emit(item.get_item_handbook_key())
	inspect_requested.emit()
	inspect_item_selected.emit(item)
	show()

func _hiding() -> void:
	inspect_item_selected.emit(null)


