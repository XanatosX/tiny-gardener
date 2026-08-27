extends Node

signal settings_changed(settings: GameSettings)

const SAVE_PATH: String = "user://settings.tres"

var _game_settings: GameSettings = null

## @TODO: Placeholder method to get all the bits and pieces into place.
## Should be replaced with a proper implementation later on
func get_settings() -> GameSettings:
	return _load_settings()

func _load_settings() -> GameSettings:
	if _game_settings != null:
		return _game_settings
	_game_settings = null

	if FileAccess.file_exists(SAVE_PATH):
		var loaded_settings: GameSettings = ResourceLoader.load(SAVE_PATH) as GameSettings
		if loaded_settings != null:
			_game_settings = loaded_settings

	if _game_settings == null:
		_game_settings = _create_settings()
		if not _save_settings():
			push_error("Could not save settings")

	return _game_settings

func _create_settings() -> GameSettings:
	return GameSettings.new()

func update_settings(new_settings: GameSettings) -> bool:
	if new_settings == null:
		return false
	new_settings.creation_date = _game_settings.creation_date
	return _save_settings()

## Callable will take a [GameSetting] object, and does need to return the identically object type
func update_settings_callback(callback: Callable) -> bool:
	if _game_settings == null:
		_game_settings = _create_settings()
	var new_settings: GameSettings = callback.call(_game_settings)
	return update_settings(new_settings)

func _save_settings() -> bool:
	if _game_settings == null:
		return false
	_game_settings.last_modified_date = Time.get_unix_time_from_system()
	_game_settings.game_version = ProjectSettings.get("application/config/version")
	var result: int = ResourceSaver.save(_game_settings, SAVE_PATH)
	if result == OK:
		_game_settings = _load_settings()
		settings_changed.emit(_game_settings)
		return _game_settings != null
	return false