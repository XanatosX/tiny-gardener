@abstract
class_name VisibleCondition extends Resource

## Connect this condition to any system if required, the condition can then perform actions regarding
@abstract func hook_up(_systems: Systems, controlled_node: Conditional3DObject) -> void
@abstract func is_visible() -> bool

func destroy(_controlled_node: Conditional3DObject) -> void:
	pass