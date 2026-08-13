class_name TeleportDoor extends SignalTrigger

enum Target
{
	NONE,
	HOUSE,
	FARM
}

## Callable will take a "TextTranslation" as argument and must return a String
signal set_transform_name_method(method: Callable)

## Callable will take a "TextTranslation" as argument and must return a String
signal set_transform_description_method(method: Callable)

## Callable will get a "Action.Type" and must return a Texture2D, if null is returned the action icon is used instead
signal set_update_action_icon_method(method: Callable)

## This is the type of target this door is
@export var location: Target
## The teleported target type to teleport to
@export var target: Target

@export var target_name: TextTranslation
@export var location_name: TextTranslation
@export var go_to_icon_overwrite: Texture2D = null

@onready var _systems: Systems = $"/root/MainGame/%Systems"
@onready var _search_area: Area3D = $"%SearchArea"
@onready var _exit: Node3D = $"%Exit"


var _teleport_system: TeleportSystem:
	get():
		if _teleport_system == null:
			_teleport_system = _systems.get_system("TeleportSystem")
		return _teleport_system

func _ready() -> void:
	assert(_systems != null, "Missing systems node")
	assert(_teleport_system != null, "Missing teleport systems node")
	assert(_search_area != null, "Missing search area")
	assert(_exit != null, "Missing exit point")
	assert(target_name != null, "Missing location translation")
	assert(location_name != null, "Missing target translation")

	if not _teleport_system.ready:
		await  _teleport_system.ready
	_teleport_system.register_door(self)
	triggered.connect(_trigger_teleport)
	_update_action_transform()

func _update_action_transform() -> void:
	set_transform_name_method.emit(_transform_method)
	set_transform_description_method.emit(_transform_method)
	set_update_action_icon_method.emit(_transform_action_icon)

func _transform_method(translation: TextTranslation) -> String:
	return translation.get_text() % target_name.get_text()

func _transform_action_icon(type: Action.Type) -> Texture2D:
	if type == Action.Type.Trigger:
		return go_to_icon_overwrite
	return null

func get_teleport_exit() -> Node3D:
	return _exit

func _trigger_teleport() -> void:
	if not _teleport_system.has_teleport_target(target):
		push_error("Missing teleport target!")
		return
	_teleport_system.teleport_to_target(self, _get_player())
	pass

func _get_player() -> Node3D:
	for body: Node3D in _search_area.get_overlapping_bodies():
		if body is PlayerController:
			return body
	return null