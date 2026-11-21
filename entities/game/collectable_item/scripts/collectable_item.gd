@tool
class_name CollectableItemTool extends DynamicItemNodeTool 

@export_tool_button("Update from resource") var update_action: Callable = _add_representation
@export var item_data: CollectableItem = null:
	set(value):
		item_data = value
		if item_data != null and item_data.representation != null:
			item_representation = item_data.representation

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if systems == null:
		push_error("Missing system")
		return
	var game_data_system: GameDataSystem = systems.get_system("GameDataSystem")
	if game_data_system == null:
		push_error("Missing game data system!")
		return
	if game_data_system.has_item(item_data):
		visible = false
		queue_free()

func _add_representation() -> void:
	if item_data.representation != null:
		item_representation = item_data.representation
	super()

func _additional_validation() -> bool:
	if item_data == null:
		push_warning("Missing item data")
		return false

	return true

