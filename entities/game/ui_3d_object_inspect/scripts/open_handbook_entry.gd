class_name OpenHandbookEntry extends Button

var _game_systems: Systems:
	get():
		if _game_systems == null:
			_game_systems = $"/root/MainGame/%Systems"
		return _game_systems

var _handbook_system: HandbookSystem:
	get():
		if _handbook_system == null:
			_handbook_system = _game_systems.get_system("HandbookSystem")
		return _handbook_system

var _current_key: String = ""

func set_identifier(identifier: String) -> void:
	if identifier == "":
		reset()
		return
	visible = true
	_current_key = identifier

func reset() -> void:
	visible = false
	_current_key = ""

func _pressed() -> void:
	_handbook_system.open_handbook_entry_by_key(_current_key)