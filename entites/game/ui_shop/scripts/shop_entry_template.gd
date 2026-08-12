class_name ShopEntryTemplate extends PanelContainer

signal was_clicked(item: Item)

signal texture_changed(texture: Texture)
signal quality_changed(texture: Texture)
signal quality_text_changed(quality_name: String)
signal name_changed(name: String)
signal update_quantity(amount: String)
signal price_changed(amount: String)

var _item: Item = null
@onready var _trigger: BaseButton = $"%Trigger"

@export var max_display_amount: int = 99

func _ready() -> void:
	_trigger.pressed.connect(func() -> void: was_clicked.emit(_item))

func setup(item: Item, sell_mode: bool, available_amount: int) -> void:
	_item = item
	texture_changed.emit(_item.icon)
	name_changed.emit(_item.get_display_name())	
	
	quality_changed.emit(_item.get_quality_icon())
	quality_text_changed.emit(_item.get_quality_name())

	var price: float = item.get_price()
	if sell_mode:
		price = item.get_sell_price()
	price_changed.emit(_convert_price(price))
	
	var display_amount: String = ""
	if sell_mode:
		display_amount = str(available_amount)
		if available_amount > 99:
			display_amount = "99+"
	update_quantity.emit(display_amount)

func _convert_price(price: float) -> String:
	return "%1.2f" % price

func get_item() -> Item:
	return _item

func select() -> void:
	was_clicked.emit(_item)
