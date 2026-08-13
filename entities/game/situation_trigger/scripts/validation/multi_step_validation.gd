class_name MultiStepValidation extends SituationValidation

@export var validators: Array[SituationValidation]

func is_valid(systems: Systems) -> bool:
	for validator: SituationValidation in validators:
		if not validator.is_valid(systems):
			return false
	return true

