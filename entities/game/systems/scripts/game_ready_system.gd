class_name GameReadySystem extends System

signal game_ready()

var _pots_spawned: bool = false

func pots_spawned() -> void:
	_pots_spawned = true
	_check_if_ready()

func _check_if_ready() -> void:
	if game_is_ready():
		game_ready.emit()

func game_is_ready() -> bool:
	return _pots_spawned