class_name HandbookSystem extends System

signal open_handbook_page(key: String)

func open_handbook() -> void:
	Input.action_press("help")

func open_handbook_entry(identifier: HandbookEntryIdentifier) -> void:
	open_handbook_entry_by_key(identifier.key)

func open_handbook_entry_by_key(key: String) -> void:
	open_handbook_page.emit(key)