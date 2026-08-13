class_name ProductInformationUi extends MarginContainer

signal icon_changed(texture: Texture)
signal quality_changed(texture: Texture)
signal quality_text_changed(text: String)

signal name_changed(text: String)
signal description_changed(text: String)
signal price_changed(text: String)

signal amount_changed(new_amount: int)

signal buy_sell_changed(text: String)
signal item_amount_changed()

@export var buy_text: TextTranslation = null
@export var sell_text: TextTranslation = null

var _interaction_amount: int = 1
var _item: Item = null
var _selling: bool

@onready var _game_systems: Systems = $"/root/MainGame/%Systems"
var _game_data_system: GameDataSystem:
	get():
		if _game_data_system == null:
			_game_data_system = _game_systems.get_system("GameDataSystem")
		return _game_data_system

func item_changed(item: Item, sell_item: bool) -> void:
	if not is_node_ready():
		await self.ready
	_item = item
	_selling = sell_item
	
	var buy_sell_text: String = buy_text.get_text()
	if _selling:
		buy_sell_text = sell_text.get_text()

	buy_sell_changed.emit(buy_sell_text)
	icon_changed.emit(_item.icon)
	name_changed.emit(_item.get_display_name())
	description_changed.emit(_item.description.get_text())
	quality_changed.emit(_item.get_quality_icon())
	quality_text_changed.emit(_item.get_quality_name())

	_interaction_amount = 1
	_communicate_price()

func increase_amount() -> void:
	_interaction_amount += 1
	_communicate_price()

func decrease_amount() -> void:
	_interaction_amount -= 1
	_communicate_price()

func amount_was_changed(data: String) -> void:
	if not data.is_valid_int():
		_communicate_price()
	_interaction_amount = int(data)
	_communicate_price()

func _communicate_price() -> void:
	var max_amount: int = clampi(_get_max_amount(), 0, 500)
	
	_interaction_amount = clampi(_interaction_amount, 0, max_amount)
	if max_amount == 0:
		amount_changed.emit(str(0))
		price_changed.emit(_convert_to_price(0.0))
		return
	var price: float =_get_item_price()
	var real_price: float = _interaction_amount * price
	amount_changed.emit(str(_interaction_amount))
	price_changed.emit(_convert_to_price(real_price))

func _get_item_price() -> float:
	var price: float = _item.get_price()
	if _selling:
		price = _item.get_sell_price()
	return price

func _get_max_amount() -> int:
	if _item is UpgradeItem:
		return _get_max_upgrade_amount() 
	if _selling:
		return _game_data_system.get_item_count(_item)
	if _get_item_price() == 0:
		return 99
	return floori(_game_data_system.get_money() / _get_item_price())

func _get_max_upgrade_amount() -> int:
	if _get_item_price() == 0:
		return 1
	var amount: int = floori(_game_data_system.get_money() / _get_item_price())
	return clampi(amount, 0, 1)

func _convert_to_price(price: float) -> String:
	return "%1.2f" % price

func button_clicked() -> void:
	if _interaction_amount <= 0:
		return
	
	if _selling:
		_sell_item()
		return
	_buy_item()

func _sell_item() -> void:
	_game_data_system.sell_item(_item, _interaction_amount)
	_communicate_price()
	item_amount_changed.emit()

func _buy_item() -> void:
	var price: float = _get_item_price() * _interaction_amount
	if price > _game_data_system.get_money():
		return
	if _game_data_system.change_money(-price):
		_game_data_system.add_item(_item, _interaction_amount)
		_communicate_price()
		_item.bought()
		item_amount_changed.emit()
	