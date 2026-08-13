class_name SaveGame extends Resource

const seeds_directory: String = "res://entities/shared/custom_resources/items/plants/"
const save_path: String = "user://save.res"
const save_path_debug: String = "user://save.tres"

@export var creation_unix_time: float
@export var last_save_date_unix_time: float

@export var day_time_tick: int = 0

@export var game_data: GameData
@export var sequences: Sequences
@export var player_ports: Dictionary[int, PotSave]
@export var player_position: Vector3

func _init() -> void:
	creation_unix_time = Time.get_unix_time_from_system()

static func get_save_path() -> String:
	if OS.is_debug_build():
		return save_path_debug
	return save_path

## Load a save game if present, otherwise returns null
static func load() -> SaveGame:
	if not FileAccess.file_exists(SaveGame.get_save_path()):
		return null
	var data: Resource = load(SaveGame.get_save_path())
	if data is SaveGame:
		return data
	return null

static func clear() -> void:
	if FileAccess.file_exists(SaveGame.get_save_path()):
		DirAccess.remove_absolute(SaveGame.get_save_path())

func save(current_game_data: GameData, pots: Dictionary[int, Pot], player: PlayerController) -> bool:
	last_save_date_unix_time = Time.get_unix_time_from_system()
	game_data = current_game_data
	for index: int in pots.keys():
		player_ports.set(index, pots.get(index).get_saveable_pot())
	player_position = player.global_position
	return ResourceSaver.save(self, SaveGame.get_save_path()) == Error.OK
