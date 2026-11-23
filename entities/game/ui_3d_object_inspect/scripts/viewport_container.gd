class_name InspectViewportContainer extends SubViewportContainer

signal rotation_changed(delta_rotation: Vector3)

@export var sensitivity: float= 0.01
var _rotating: bool= false

func enabled() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT

func disabled() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_rotating = event.pressed

	if event is InputEventMouseMotion and _rotating:
		var delta: Vector3= Vector3(
			event.relative.y * sensitivity,   # Festhalten/Neigen (= X-Achse)
			event.relative.x * sensitivity,   # Drehen (= Y-Achse)
			0.0
		)
		rotation_changed.emit(delta)