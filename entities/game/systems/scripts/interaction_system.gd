class_name InteractionSystem extends System

signal show_pot_information_ui(pot: PotVisuals)
signal hide_pot_information_ui()

signal update_actions(available_actions: Array[Action])

@export var tracked_player: PlayerController

var _nearby_interactable_objects: Array[ObjectInteraction] = []

func _init() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func trigger_interaction(type: Action.Type, item: Item) -> void:
	var interactable_object: ObjectInteraction = _get_nearest_interactable_object()
	if interactable_object == null:
		print("no object nearby")
		return
	if interactable_object.execute_action(type, item):
		_update_pot_information()
		_action_update_requested()

func _has_interactable_object(interactable_object: ObjectInteraction) -> bool:
	return _nearby_interactable_objects.find(interactable_object) != -1

func add_active_area(interactable_object: ObjectInteraction) -> void:
	if not _has_interactable_object(interactable_object):
		_nearby_interactable_objects.append(interactable_object)
		_update_pot_information()
		interactable_object.update_available_actions.connect(_action_update_requested)
		_action_update_requested()

func _update_pot_information() -> void:
	var _nearest: ObjectInteraction = _get_nearest_interactable_object()
	if _nearest.controlled_entity is PotVisuals:
		show_pot_information_ui.emit(_nearest.controlled_entity)

func remove_active_area(intractable_object: ObjectInteraction) -> void:
	_nearby_interactable_objects.erase(intractable_object)
	intractable_object.update_available_actions.disconnect(_action_update_requested)
	if _nearby_interactable_objects.filter(func(object: ObjectInteraction) -> bool: return object.controlled_entity is PotVisuals).size() == 0:
		hide_pot_information_ui.emit()
	_action_update_requested()

func _action_update_requested() -> void:
	var object: ObjectInteraction = _get_nearest_interactable_object()
	if object == null:
		var empty_actions: Array[Action] = []
		update_actions.emit(empty_actions)
		return
	update_actions.emit(object.get_valid_actions())

func _get_nearest_interactable_object() -> ObjectInteraction:
	var return_data: ObjectInteraction = null
	var distance: float = INF
	for object: ObjectInteraction in _nearby_interactable_objects:
		var current_distance: float = tracked_player.global_position.distance_to(object.controlled_entity.global_position)
		if current_distance < distance:
			distance = current_distance
			return_data = object

	return return_data