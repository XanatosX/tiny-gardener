class_name ShowDialogStep extends SituationStep

signal _dialog_played()

@export var dialog: Dialog = null

func execute(on_finished: Callable,
			systems: Systems,
			_main_game: Node3D,
			_situation_objects: Array[SituationObject]) -> void:
	var dialog_system: DialogSystem = systems.get_system("DialogSystem")
	dialog_system.dialog_done.connect(_dialog_finished)
	dialog_system.show_dialog(dialog)
	await _dialog_played
	dialog_system.dialog_done.disconnect(_dialog_finished)
	on_finished.call()

func _dialog_finished(player_dialog: Dialog) -> void:
	if player_dialog == dialog:
		_dialog_played.emit()