class_name ItemHandbookEntry extends HandbookEntry

var item_reference: WeakRef

func get_entry_data() -> HandbookTemplate:
	var instance: HandbookTemplate = _get_template_instance()
	if instance == null:
		return null
	instance.set_data(self)
	return instance
