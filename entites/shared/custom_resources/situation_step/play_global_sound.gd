class_name PlayGlobalSound extends SituationStep

@export var sound_effect: AudioStream


func execute(_on_finished: Callable,
			_systems: Systems,
			_main_game: Node3D,
			_situation_objects: Array[SituationObject]) -> void:
	AudioService.play_global_audio_effect(sound_effect)
