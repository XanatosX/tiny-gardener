class_name TeleportSystem extends System

@export var transition_ui: TeleportTransitionUi

var _teleport_targets: Dictionary[TeleportDoor.Target, TeleportDoor] = {}


func register_door(door: TeleportDoor) -> bool:
	if _teleport_targets.has(door.location) or door.location == TeleportDoor.Target.NONE or door.target == TeleportDoor.Target.NONE:
		return false
	_teleport_targets.set(door.location, door)
	return true

func has_teleport_target(target: TeleportDoor.Target) -> bool:
	return _teleport_targets.keys().has(target)

func teleport_to_target(from: TeleportDoor, object: Node3D) -> void:
	if object == null or from == null or from.location == TeleportDoor.Target.NONE:
		return
	if from.target == from.location:
		push_error("Door is not configured correctly")
		return
	if not has_teleport_target(from.target):
		return
	
	var target: TeleportDoor = _teleport_targets.get(from.target)
	if transition_ui == null:
		_set_object_position(object, target)
		return
	transition_ui.transit()
	await transition_ui.fully_black
	_set_object_position(object, target)

func _set_object_position(object: Node3D, target: TeleportDoor) -> void:
	object.global_position = target.get_teleport_exit().global_position
	object.rotation = target.get_teleport_exit().rotation