class_name ItemHandbookEntry extends HandbookEntry

var item_reference: WeakRef

func get_entry_data() -> HandbookTemplate:
	var instance: HandbookTemplate = _get_template_instance()
	if instance == null:
		return null
	instance.set_data(self)
	return instance

func is_unlocked() -> bool:
	return super() and _unlock_bridge.item_is_known(item_reference.get_ref())