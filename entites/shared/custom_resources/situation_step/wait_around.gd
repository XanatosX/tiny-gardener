class_name WaitStep extends SituationStep

@export var wait_time_seconds: float

func execute(_on_finished: Callable,
			 _systems: Systems,
			 main_game: Node3D,
			 _situation_objects: Array[SituationObject]) -> void:
	await main_game.get_tree().create_timer(wait_time_seconds).timeout
