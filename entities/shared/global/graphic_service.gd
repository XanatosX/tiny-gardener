extends Node

var _current_graphic_settings: GraphicSettings = null
var in_game: bool = true

func _ready() -> void:
	SettingsService.settings_changed.connect(_settings_changed)
	_settings_changed(SettingsService.get_settings())

func _settings_changed(settings: GameSettings) -> void:
	_current_graphic_settings = settings.graphic_settings
	set_fps()
	DisplayServer.window_set_vsync_mode(_current_graphic_settings.vsync)

func set_fps() -> void:
	if in_game:
		is_in_game()
		return
	is_in_menu()

func is_in_menu() -> void:
	if _current_graphic_settings == null:
		return
	Engine.max_fps = _current_graphic_settings.menu_max_fps

func is_in_game() -> void:
	if _current_graphic_settings == null:
		return
	Engine.max_fps = _current_graphic_settings.ingame_max_fps