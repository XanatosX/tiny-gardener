class_name MoveableCamera extends Camera3D

@export var movement_speed: float = 5.0
@export var mouse_sensitivity: float = 1
@export var max_pitch_down_degrees: float = 45.0
@export var rotation_step: float = 45.0

var _camera_pivot: Node3D
var _yaw_target: float = 0

var _can_move: bool =  true

func _ready() -> void:
	_camera_pivot = $"%CameraPivot"
	assert(_camera_pivot != null, "Missing \"CameraPivor\" node with unique identifier")

func _process(delta: float) -> void:
	if not _can_move:
		return
	_handle_rotation(delta)

func _handle_rotation(_delta: float) -> void:
	if Input.is_action_just_pressed("camera_left"):
		_yaw_target += 90
	if Input.is_action_just_pressed("camera_right"):
		_yaw_target -= 90

	if is_equal_approx(rad_to_deg(rotation.y), _yaw_target):
		return
	var tween: Tween = create_tween()
	tween.tween_property(_camera_pivot, "rotation", Vector3(rotation.x, deg_to_rad(_yaw_target), rotation.z), 0.5)


func _handle_movement(delta: float) -> void:
	var z_axis: float = Input.get_axis("forward", "backward")
	var x_axis: float = Input.get_axis("left", "right")

	var direction: Vector3 = Vector3(x_axis, 0, z_axis).normalized()
	var movement: Vector3 = global_transform.basis * direction * movement_speed * delta

	global_position.x += movement.x
	global_position.z += movement.z

func movement_state_changed(new_state: bool) -> void:
	_can_move = new_state