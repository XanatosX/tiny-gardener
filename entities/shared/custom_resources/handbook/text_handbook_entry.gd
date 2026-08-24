class_name TextHandbookEntry extends HandbookEntry

@export var handbook_parts: Array[HandbookTextType]
@export var unlock_conditions: Array[UnlockCondition]

func get_entry_data() -> HandbookTemplate:
	var instance: HandbookTemplate = _get_template_instance()
	if instance == null:
		return null
	instance.set_data(self)
	return instance

func is_unlocked() -> bool:
	var unlocked: bool = true
	for condition: UnlockCondition in unlock_conditions:
		if not condition.is_unlocked(_unlock_bridge):
			unlocked = false
			break
	return super() and unlocked
