class_name TogglePlayerStep extends SituationStep

@export var disable_player: bool = false

func execute(on_finished: Callable,
			_systems: Systems,
			main_game: Node3D,
			_situation_objects: Array[SituationObject]) -> void:
	var player: PlayerController = main_game.find_child("Player", true)
	if player == null:
		on_finished.call()
		return
	player.toggle_movement(not disable_player)
	on_finished.call()
