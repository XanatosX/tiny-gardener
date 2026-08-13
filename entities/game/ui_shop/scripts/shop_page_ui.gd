class_name ShopPageUi extends MarginContainer

signal clear_items()
signal add_items(items: Dictionary[Item, int], selling: bool)
signal item_was_clicked(item: Item, selling: bool)

@export var is_buy_page: bool = true

@onready var _game_systems: Systems = $"/root/MainGame/%Systems"

var _items: Dictionary[Item, int] = {}
var _game_data_system: GameDataSystem:
	get():
		if _game_data_system == null:
			_game_data_system = _game_systems.get_system("GameDataSystem")
		return _game_data_system

func _ready() -> void:
	if not is_instance_valid(_game_systems):
		await _game_systems.ready
	_build_item_view()

func rebuild() -> void:
	_build_item_view()

func _build_item_view() -> void:
	clear_items.emit()
	if is_buy_page and _items.size() == 0:
		_items = _load_buyable_products()
	else:
		_items = _load_sellable_items()
		
	add_items.emit(_items, not is_buy_page)

func _load_buyable_products() -> Dictionary[Item, int]:
	var return_data: Dictionary[Item, int] = {}
	for item: Item in ItemService.get_all_items():
		if item.can_buy:
			return_data.set(item, 1)

	return return_data

func _load_sellable_items() -> Dictionary[Item, int]:
	var return_data: Dictionary[Item, int] = {}
	for item: Item in _game_data_system.get_items():
		if item.can_sell:
			return_data.set(item, _game_data_system.get_item_count(item))

	return return_data

func item_clicked_forward(item: Item) -> void:
	item_was_clicked.emit(item, not is_buy_page)