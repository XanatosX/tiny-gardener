class_name TextHandbookEntry extends HandbookEntry

@export var handbook_parts: Array[HandbookTextType]

func get_entry_data() -> HandbookTemplate:
	var instance: HandbookTemplate = _get_template_instance()
	if instance == null:
		return null
	instance.set_data(self)
	return instance
