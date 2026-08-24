class_name SaveGameSystem extends System

signal game_loaded(save: SaveGame)
signal game_saving(save: SaveGame)
signal saving_started()
signal game_saved()

@export var initial_game_state: GameData
@export var player: PlayerController

var _loaded_save: SaveGame
var _auto_save_timer: Timer = null

var _game_data_system: GameDataSystem:
	get():
		if _game_data_system == null:
			_game_data_system = _systems.get_system("GameDataSystem")
		return _game_data_system

var _pot_management_system: PotManagerSystem:
	get():
		if _pot_management_system == null:
			_pot_management_system = _systems.get_system("PotManagerSystem")
		return _pot_management_system

func _ready() -> void:
	super()
	assert(initial_game_state != null, "Missing initial save")
	assert(player != null, "Missing player")
	tree_exiting.connect(_unregister_commands)
	_register_commands()

	var settings: GameSettings = SettingsService.get_settings()
	var auto_save_interval_seconds: float = settings.auto_save_interval_minutes * 60
	_auto_save_timer = Timer.new()
	_auto_save_timer.one_shot = false
	add_child(_auto_save_timer)
	_auto_save_timer.timeout.connect(save_game)
	if settings.auto_save_active:
		_auto_save_timer.start(auto_save_interval_seconds)

func _register_commands() -> void:
	Console.register_command(Command.create("save")
									.calling_method(save_game)
									.documentation()
									.with_description("Save the game")
									.with_long_description("This command will save the game")
									.finalize()
							)
	Console.register_command(Command.create("delete_save")
									.calling_method(clear_save)
									.documentation()
									.with_description("Clear the save file")
									.finalize()
							)

func _unregister_commands() -> void:
	Console.remove_command("save")
	Console.remove_command("delete_save")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quicksave"):
		save_game()

func save_game() -> void:
	saving_started.emit()
	var game_data: GameData = _game_data_system.game_data
	var pots: Dictionary[int, Pot] = _pot_management_system.get_relevant_pots()

	game_saving.emit(_loaded_save)
	_loaded_save.save(game_data, pots, player)
	game_saved.emit()

func load_game() -> void:
	var loaded_save: SaveGame = SaveGame.load()
	if loaded_save == null:
		loaded_save = _create_new_save()
	
	_loaded_save = loaded_save
	assert(_loaded_save != null, "Something went wrong, creating a save game")
	game_loaded.emit(_loaded_save)

func clear_save() -> void:
	SaveGame.clear()

func _create_new_save() -> SaveGame:
	var return_save: SaveGame = SaveGame.new()
	return_save.game_data = initial_game_state.duplicate_deep()
	return_save.player_position = player.global_position
	return_save.sequences = Sequences.new()
	return return_save
