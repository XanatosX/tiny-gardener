class_name PotManagerSystem extends System

signal pots_initialized()

@export var rows: int = 1
@export var columns: int = 1
@export var separation_in_meter: float = 1
@export var pot_template: PackedScene
@export var target_node: Node3D
@export_group("Debug")
@export var fully_unlocked: bool = false

var _growth_system: GrowthSystem:
	get():
		if _growth_system == null:
			_growth_system =  _systems.get_system("GrowthSystem")
			assert(_growth_system != null, "Missing growth system")
		return _growth_system

var _nutrition_system: NutritionRestoreSystem:
	get():
		if _nutrition_system == null:
			_nutrition_system =  _systems.get_system("NutritionRestoreSystem")
			assert(_nutrition_system != null, "Missing nutrition system")
		return _nutrition_system

var _pot_collection: Dictionary[int, PotVisuals] = {}
var _current_pot_index: int = 0

func _ready() -> void:
	super()
	if not _systems.is_node_ready():
		await _systems.ready
	_spawn_pots()
	Console.register_command(Command.create("unlock_pot")
	                                .calling_method(_console_unlock_pot)
									.with_argument(CommandArgument.create("amount")
									                              .of_type(CommandArgument.Type.INT)
																  .with_description("Number of pots to unlock")
																  .with_default_value("1")
																  .with_predefined_value(1)
																  .with_predefined_value(5)
																  .with_predefined_value(10)
																  .finalize() 
												  )
									.documentation()
									.with_description("Add n amount of pots to the grid")
									.with_long_description("Command will unlock n pots to be used as planting pots")
									.finish()
							)
	pots_initialized.emit()

func _console_unlock_pot(amount: int) -> void:
	for i: int in amount:
		unlock_pot()

func _create_new_pot() -> PotVisuals:
	var pot: PotVisuals = pot_template.instantiate() as PotVisuals
	return pot
		
func _spawn_pots() -> void:	
	var offset: Vector3 = Vector3((rows * separation_in_meter) / 2, 0, (columns * separation_in_meter) / 2)
	var id: int = 0
	for x: int in rows:
		for y: int in columns:
			var pot_visuals: PotVisuals = _create_new_pot()
			_growth_system.register_pot(id, pot_visuals.pot)
			_nutrition_system.register_pot(pot_visuals.pot)
			pot_visuals.position = Vector3(x * separation_in_meter, 0, y * separation_in_meter) - offset
			target_node.add_child(pot_visuals)
			pot_visuals.toggle_active_state(false)
			_pot_collection.set(id, pot_visuals)
			id += 1

func unlock_pot() -> void:
	if _current_pot_index > _pot_collection.size():
		return
	var index: int = clampi(_current_pot_index, 0, _pot_collection.size())
	_pot_collection[index].toggle_active_state(true)
	_current_pot_index += 1

func game_loaded(save: SaveGame) -> void:
	for index: int in save.player_ports.keys():
		if _pot_collection.has(index):
			var relevant_pot: PotVisuals = _pot_collection.get(index)
			var save_pot: PotSave = save.player_ports.get(index)
			relevant_pot.restore(save_pot)
			relevant_pot.toggle_active_state(true)
			_growth_system.replace_pot(index, relevant_pot.pot)
			_current_pot_index += 1

func get_relevant_pots() -> Dictionary[int, Pot]:
	var relevant: Dictionary[int, Pot]
	for index: int in _pot_collection.keys():
		var pot_visuals: PotVisuals = _pot_collection.get(index)
		if pot_visuals.is_unlocked():
			relevant.set(index, pot_visuals.pot)

	return relevant
