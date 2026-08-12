class_name ShowHandbookEntryStep extends SituationStep

@export var entry_identifier: HandbookEntryIdentifier

func execute(on_finished: Callable,
					   _systems: Systems,
					   _main_game: Node3D,
					   _situation_objects: Array[SituationObject]) -> void:
	var handbook_service: HandbookSystem = _systems.get_system("HandbookSystem")
	if handbook_service == null:
		return
	handbook_service.open_handbook()
	handbook_service.open_handbook_entry(entry_identifier)
	on_finished.call()