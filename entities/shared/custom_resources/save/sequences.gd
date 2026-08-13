class_name Sequences extends Resource

@export var seen_situations: Array[Situation] = []

func get_all_seen_situations() -> Array[Situation]:
	return seen_situations

func situation_seen(situation: Situation) -> bool:
	return situation in get_all_seen_situations()

func add_known_situations(situation: Situation) -> void:
	seen_situations.append(situation)
