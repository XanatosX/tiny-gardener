class_name ShopItemContainer extends GridContainer

signal item_clicked(item: Item)

@export var template: Node = null

var current_entries: Array[ShopEntryTemplate] = []

func _ready() -> void:
	assert(template != null, "Missing item template")
	assert(template is InstancePlaceholder, "No instance placeholder")

func clear_entries() -> void:
	for entry: ShopEntryTemplate in current_entries:
		entry.visible = false
		entry.process_mode = Node.PROCESS_MODE_DISABLED
	
func add_new_entries(data: Dictionary[Item, int], selling: bool) -> void:
	var data_keys: Array[Item] = data.keys()
	data_keys.sort_custom(_sort_items.bind(selling))
	for item: Item in data_keys:
		var item_template: ShopEntryTemplate = _get_shop_entry()
		item_template.setup(item, selling, data.get(item))

	if current_entries.size() > 0 and not selling:
		for entry: ShopEntryTemplate in current_entries:
			if entry.visible:
				item_clicked.emit(entry.get_item())
				return

func _sort_items(a: Item, b: Item, selling: bool) -> bool:
	var a_price: float = a.get_price()
	var b_price: float = b.get_price()
	if selling:
		a_price = a.get_sell_price()
		b_price = b.get_sell_price()
	if a_price == b_price:
		if a.display_name == b.display_name:
			return a.quality < b.quality
		return a.display_name.get_text() < b.display_name.get_text()
	return a_price < b_price


func _get_shop_entry() -> ShopEntryTemplate:
	var entry: ShopEntryTemplate = null
	for shop_template: ShopEntryTemplate in current_entries:
		if not shop_template.visible:
			entry = shop_template
			entry.visible = true
			entry.process_mode = Node.PROCESS_MODE_INHERIT
			return entry
	var template_node: InstancePlaceholder = template as InstancePlaceholder
	entry = template_node.create_instance()
	current_entries.append(entry)
	entry.was_clicked.connect(func(item: Item) -> void: item_clicked.emit(item))
	return entry
