class_name VSyncMode extends Label

@export var translations: Dictionary[DisplayServer.VSyncMode, TextTranslation] = {}

func _ready() -> void:
	SettingsService.settings_changed.connect(_settings_changed)
	_settings_changed(SettingsService.get_settings())

func _settings_changed(settings: GameSettings) -> void:
	text = _translate_mode(settings.graphic_settings.vsync)

func _translate_mode(mode: DisplayServer.VSyncMode) -> String:
	if not translations.has(mode):
		return str(mode)
	var translation: TextTranslation = translations.get(mode)
	return translation.get_text()
