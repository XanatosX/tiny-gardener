class_name UIItemDisplay extends MarginContainer

class MessageData:
	func _init(item_data: Item, amount: int) -> void:
		item = item_data
		item_amount = amount

	var item: Item
	var item_amount: int

@export var max_entries: int = 7
@export var template_placeholder: Node = null
@export var template_root_node: Node = null
@export var spawn_offset: Vector2 = Vector2.ZERO

var instance_pool: Array[UiItemDisplayTemplate] = []
var _queue_messages: Array[MessageData] = []
var _park_node: Node

func _ready() -> void:
	assert(template_placeholder != null, "Missing placeholder to spawn")
	assert(template_root_node != null, "Missing template root node")
	_park_node = Node.new()
	_park_node.name = "TemplateParkNode"
	add_child(_park_node)


func add_new_item(item: Item, amount: int) -> void:
	if not is_node_ready():
		await ready
	if _get_display_count() > max_entries:
		_queue_messages.append(MessageData.new(item, amount))
		return
	var instance: UiItemDisplayTemplate = _get_new_instance()
	
	instance.set_data(item, amount, spawn_offset)
	instance.timeout.connect(_destroy_instance.bind(instance))
	instance.enable()

func _destroy_instance(instance: UiItemDisplayTemplate) -> void:
	instance.disable()
	instance.timeout.disconnect(_destroy_instance)
	instance_pool.append(instance)
	instance.reparent(_park_node)
	_check_for_queued_items()

func _check_for_queued_items() -> void:
	if _get_display_count() > max_entries:
		return
	if _queue_messages.size() == 0:
		return
	
	var data: MessageData = _queue_messages.pop_front()
	add_new_item(data.item, data.item_amount)

func _get_display_count() -> int:
	return template_root_node.get_child_count()

func _get_new_instance() -> UiItemDisplayTemplate:
	if instance_pool.size() > 0:
		var instance: UiItemDisplayTemplate = instance_pool.pop_front()
		instance.reparent(template_root_node)
		return instance
	return template_placeholder.create_instance() as UiItemDisplayTemplate