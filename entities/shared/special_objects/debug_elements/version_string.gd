class_name VersionString extends Label

@export var version_translation: TextTranslation
var _version: String = ""


func _ready() -> void:
	_version = ProjectSettings.get("application/config/version")
	text = version_translation.get_text() % _version
	
