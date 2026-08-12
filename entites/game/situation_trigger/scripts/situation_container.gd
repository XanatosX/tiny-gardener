class_name SituationContainer extends Node3D

@export var situation: Situation
## A list of objects which are relevant for this situation
@export var situation_objects: Array[SituationObject]
@export var enabled: bool = true

@export var validation: SituationValidation


var _systems: Systems:
	get():
		if _systems == null:
			_systems = $"/root/MainGame/%Systems"
		return _systems

var _situation_manager: SituationManager:
	get():
		if _situation_manager == null:
			_situation_manager = _systems.get_system("SituationManager")
		return _situation_manager

func _ready() -> void:
	assert(situation != null, "Missing situation")

func trigger_situation() -> void:
	if not enabled:
		return
	if not validation == null and not validation.is_valid(_systems):
		return
	_situation_manager.play_situation(situation, situation_objects)
