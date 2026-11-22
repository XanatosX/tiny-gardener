class_name PixellatedContainer extends SubViewportContainer

@onready var _game_systems: Systems = $"/root/MainGame/%Systems"

func _ready() -> void:
	assert(_game_systems != null, "Missing game systems")
	var save_game_system: SaveGameSystem = _game_systems.get_system("SaveGameSystem")
	assert(save_game_system != null, "Missing save game systems")
	
	save_game_system.game_loaded.connect(_settings_updated)
	if save_game_system.is_node_ready():
		_settings_updated(SettingsService.get_settings())

func _settings_updated(save: GameSettings) -> void:
	stretch_shrink = save.graphic_settings.pixelation