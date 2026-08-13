class_name AddItemStep extends SituationStep

@export var money_to_add: float = 0.0
@export var items_to_add: Dictionary[Item, int] = {}

func execute(_on_finished: Callable,
			systems: Systems,
			_main_game: Node3D,
			_situation_objects: Array[SituationObject]) -> void:
	var game_data_system: GameDataSystem = systems.get_system("GameDataSystem")
	assert(game_data_system != null, "Missing game data system")
	game_data_system.change_money(money_to_add)
	game_data_system.add_multiple_items(items_to_add)
