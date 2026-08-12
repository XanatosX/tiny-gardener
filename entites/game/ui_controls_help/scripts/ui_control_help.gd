class_name UiControlHelp extends PanelContainer

func _ready() -> void:
	visible = false

func _process(_delta: float) -> void:
	if not visible and Input.is_action_just_pressed("help"):
		show()
