class_name GameSettings extends Resource

@export var creation_date: float = 0
@export var last_modified_date: float = 0
@export var game_version: String = ""

@export var graphic_settings: GraphicSettings
@export var audio_settings: AudioSettings

@export var auto_save_interval_minutes: float = 5
@export var auto_save_active: bool = true

func _init() -> void:
	creation_date = Time.get_unix_time_from_system()
	graphic_settings = GraphicSettings.new()
	audio_settings = AudioSettings.new()
	last_modified_date = creation_date