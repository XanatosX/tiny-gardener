class_name UpgradeItemContainer extends VBoxContainer

signal item_clicked(item: Item)

@export var template: Node

var _entries: Array[ShopEntryTemplate] = []

var _active: bool = false

func _ready() -> void:
	assert(template != null, "Missing item template")
	assert(template is InstancePlaceholder, "No instance placeholder")

func clear_entries() -> void:
	for entry: ShopEntryTemplate in _entries:
		entry.visible = false
		entry.process_mode = Node.PROCESS_MODE_DISABLED

func add_items(items: Array[Item]) -> void:
	clear_entries()
	var active_set: bool = false
	for item: Item in items:
		if item is UpgradeItem:
			template = _get_template()
			template.setup(item, false, item.maximal_buyable_amount)
			if _active and not active_set:
				active_set = true
				template.select()

func _get_template() -> ShopEntryTemplate:
	var entry: ShopEntryTemplate = null
	for upgrade: ShopEntryTemplate in _entries:
		if not upgrade.visible:
			entry = upgrade
			upgrade.visible = true
			upgrade.process_mode = Node.PROCESS_MODE_INHERIT
			return upgrade
	var placeholder: InstancePlaceholder = template as InstancePlaceholder
	entry = placeholder.create_instance()
	_entries.append(entry)
	entry.was_clicked.connect(func(item: Item) -> void: item_clicked.emit(item))
	return entry

func active(state: bool) -> void:
	_active = state