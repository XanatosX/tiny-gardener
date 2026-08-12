extends Node

var _game_settings: GameSettings = null

## @TODO: Placeholder method to get all the bits and pieces into place.
## Should be replaced with a proper implementation later on
func get_settings() -> GameSettings:
	if _game_settings == null:
		_game_settings = GameSettings.new()
	return _game_settings