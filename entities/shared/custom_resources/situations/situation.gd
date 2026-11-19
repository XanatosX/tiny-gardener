class_name Situation extends Resource

## Situations which are not able to be completed will repeat until the requirements fail
@export var can_be_completed: bool = true
@export var requirements: Array[Situation]
@export var situation_steps: Array[SituationStep]

func can_show() -> void:
	pass
