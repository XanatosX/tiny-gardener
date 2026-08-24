## Object to be used with the handbook to check if something should be shown on the 
## handbook already
class_name UnlockBridge extends Node

@onready var _systems: Systems = $"%Systems"

var _game_data_system: GameDataSystem:
	get():
		if _game_data_system == null:
			_game_data_system = _systems.get_system("GameDataSystem")
		return _game_data_system

func _ready() -> void:
	assert(_systems != null, "Unlock system is missing systems")

func item_is_known(item: Item) -> bool:
	return _game_data_system.item_is_known(item)
