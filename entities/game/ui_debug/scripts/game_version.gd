class_name GameVersion extends Label

func _ready() -> void:
	text = ProjectSettings.get("application/config/version")
