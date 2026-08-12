class_name UpgradeUi extends MarginContainer

signal clear_items()
signal add_items(items: Array[Item])
signal item_was_clicked(item: Item, selling: bool)
signal active(state: bool)

@onready var _game_systems: Systems = $"/root/MainGame/%Systems"

var _my_id: int = 0

func _ready() -> void:
	_send_upgrade_list()
	var index: int = get_parent().get_children().find(self)
	_my_id = index

func rebuild() -> void:
	_send_upgrade_list()

func _send_upgrade_list() -> void:
	clear_items.emit()
	var items: Array[Item] = []
	for item: Item in ItemService.get_all_items():
		if item is UpgradeItem:
			item.init(_game_systems)
			if item.is_valid():
				items.append(item)
	add_items.emit(items)

func item_clicked(item: Item) -> void:
	item_was_clicked.emit(item, false)

func selection_changed(id: int) -> void:
	active.emit(id == _my_id)