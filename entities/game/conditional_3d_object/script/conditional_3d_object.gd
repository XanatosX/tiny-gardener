@tool
class_name Conditional3DObject extends DynamicItemNodeTool

@export var visibility_condition: VisibleCondition = null
@export var item_data: CollectableItem = null:
	set(value):
		item_data = value
		if item_data != null and item_data.representation != null:
			item_representation = item_data.representation

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	assert(visibility_condition != null, "Missing visibility condition!")
	visibility_condition.hook_up(systems, self)
	evaluate_visibility()
	tree_exiting.connect(_destroy)

func evaluate_visibility() -> void:
	visible = visibility_condition.is_visible()

func _destroy() -> void:
	visibility_condition.destroy(self)