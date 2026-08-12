class_name DialogSystem extends System

@export var dialog_ui: UiSpeakBubble

signal dialog_done(dialog: Dialog)
signal dialog_started()
signal dialog_ended()

func _ready() -> void:
	super()
	assert(dialog_ui != null, "Missing dialog ui")

func show_dialog(dialog: Dialog) -> void:
	dialog_ui.set_dialog(dialog)
	dialog_started.emit()
	await dialog_ui.dialog_done
	dialog_ended.emit()
	dialog_done.emit(dialog)
	