class_name UiHandbook extends MarginContainer

signal open_entry(key: String)
signal data_has_changed()

@export var unlock_bridge: UnlockBridge

func _ready() -> void:
	visible = false
	
func _process(_delta: float) -> void:
	if not visible and Input.is_action_just_pressed("help"):
		show()

func open_specific_handbook_entry(key: String) -> void:
	open_entry.emit(key)

func data_changed() -> void:
	data_has_changed.emit()

func get_unlock_bridge() -> UnlockBridge:
	return unlock_bridge