class_name Situation extends Resource

@export var requirements: Array[Situation]
@export var situation_steps: Array[SituationStep]

func can_show() -> void:
	pass
