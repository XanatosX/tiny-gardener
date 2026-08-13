class_name PotVisuals extends DynamicActionObject

signal set_data(plant_data: PlantData)
signal set_visual_stage(stage: int)
signal plant_deleted()
signal plant_died()

signal active_state_changed(new_state: bool)

@export var dead_plant_data: PlantData = preload("res://entities/game/plant_pot/resources/dead_plant.tres")

@onready var interaction_area: Area3D = $"%InteractionArea"


@export var pot: Pot = null:
	set(value):
		_pot = value.duplicate_deep()
		_pot.plant_died.connect(_plant_has_died)
		_last_visual_stage = 0
		if pot.has_plant():
			_last_visual_stage = pot.get_plant().get_current_stage()
		set_visual_stage.emit(_last_visual_stage)
		if pot.plant_data != null:
			set_data.emit(pot.plant_data)
	get():
		return _pot

var _last_visual_stage: int = 0
var _pot: Pot = null
var _active: bool = false

func _ready() -> void:
	if pot != null:
		set_data.emit(_pot.plant_data)
	if not _active:
		visible = false
	active_state_changed.emit(visible)

func add_plant(plant_seed: PlantData) -> void:
	if pot.plant_data != null:
		return
	pot.set_seed(plant_seed)
	set_data.emit(plant_seed)
	object_action_update.emit()

func remove_plant() -> void:
	pot.clear_plant()
	plant_deleted.emit()
	object_action_update.emit()

func plant_fully_grown() -> bool:
	return pot.plant_fully_grown()

func harvest_plant() -> Dictionary[Item, int]:
	if not plant_fully_grown():
		return {}
	var plant_yield: Dictionary[Item, int] = pot.harvest()
	remove_plant()
	return plant_yield

func _plant_has_died() -> void:
	plant_died.emit()
	remove_plant()
	add_plant(dead_plant_data)

func toggle_active_state(new_state: bool) -> void:
	_active = new_state
	visible = _active
	process_mode = Node.PROCESS_MODE_INHERIT
	if not new_state:
		process_mode = Node.PROCESS_MODE_DISABLED
	
	active_state_changed.emit(visible)
	pot.change_active_state(new_state)

func is_active() -> bool:
	return _active and pot != null and pot.has_plant()

func is_unlocked() -> bool:
	return _active

func plant_alive() -> bool:
	return pot != null and pot.has_plant() and pot.get_plant().is_alive()

func _process(_delta: float) -> void:
	if not is_active():
		return

	var plant_stage: int = pot.get_plant().get_current_stage()
	if plant_stage != _last_visual_stage:
		object_action_update.emit()
		_last_visual_stage = plant_stage
		set_visual_stage.emit(plant_stage)
	
func restore(saved_pot: PotSave) -> void:
	pot.restore(saved_pot)
	if pot.has_plant():
		set_visual_stage.emit(pot.get_plant().get_current_stage())