class_name ObjectInteraction extends Node

signal update_available_actions()

@export var controlled_entity: Node3D
@export var interaction_area: Area3D
## If set to tue this will copy all the actions, this is needed if actions are used on other places as well.
## This does prevent the action settings to be identically
@export var deep_copy_actions: bool = false
@export var actions: Array[Action] = []

@onready var systems: Systems = $"/root/MainGame/%Systems"

var _interaction_system: InteractionSystem:
	get():
		if _interaction_system == null:
			_interaction_system = systems.get_system("InteractionSystem")
		return _interaction_system

func _ready() -> void:
	assert(controlled_entity != null, "Missing controlled entity")
	assert(interaction_area != null, "Missing interaction area")
	assert(systems != null, "Missing systems node")

	if deep_copy_actions:
		var deep_copied: Array[Action] = []
		for action: Action in actions:
			deep_copied.append(action.duplicate_deep())
		actions = deep_copied


	if controlled_entity is DynamicActionObject:
		controlled_entity.object_action_update.connect(_trigger_action_update)

	interaction_area.body_entered.connect(_on_body_enter)
	interaction_area.body_exited.connect(_on_body_leave)

func _trigger_action_update() -> void:
	update_available_actions.emit()

func _on_body_enter(body: Node3D) -> void:
	if body is not PlayerController:
		return
	_interaction_system.add_active_area(self)

func _on_body_leave(body: Node3D) -> void:
	if body is not PlayerController:
		return
	_interaction_system.remove_active_area(self)

func get_valid_actions() -> Array[Action]:
	var valid_actions: Array[Action] = []
	for action: Action in get_actions():
		if action.controlled_node_has_valid_state(controlled_entity, systems):
			valid_actions.append(action)
	return valid_actions

func get_actions() -> Array[Action]:
	return actions

func execute_action(type: Action.Type, item: Item) -> bool:
	var valid_action: Action = null
	for action: Action in actions:
		if action.type == type:
			valid_action = action
			break

	if valid_action == null:
		return false
	if not valid_action.can_execute(controlled_entity, item, systems):
		return false
	return valid_action.execute(controlled_entity, item, systems)

func update_action_icons(method: Callable) -> void:
	for action: Action in actions:
		var icon: Texture2D = method.call(action.type)
		if icon != null:
			action.icon = icon

## Callable will take a "TextTranslation" as argument and must return a String
func update_actions_name_transform_methods(method: Callable) -> void:
	for action: Action in actions:
		action.set_name_transform_method(method)

## Callable will take a "TextTranslation" as argument and must return a String
func update_actions_description_transform_methods(method: Callable) -> void:
	for action: Action in actions:
		action.set_name_transform_method(method)
