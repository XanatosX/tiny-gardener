class_name SignalTriggerAction extends Action

func _init() -> void:
	type = Action.Type.Trigger
	updatable = true

func controlled_node_has_valid_state(controlled_node: Node3D, _systems: Systems) -> bool:
	return controlled_node is SignalTrigger

func can_execute(controlled_node: Node3D, _item: Item, _systems: Systems) -> bool:
	if not controlled_node is SignalTrigger:
		return false
	return true

func execute(controlled_node: Node3D, _item: Item, _systems: Systems) -> bool:
	var signal_trigger: SignalTrigger = controlled_node as SignalTrigger
	if signal_trigger == null:
		return false
	signal_trigger.trigger()
	return true
