class_name InspectObjectArea extends Node3D

signal rotate_y(y: float)
signal rotate_x(x: float)
signal rotate_z(z: float)
signal request_rotation(rotation: Vector3)

@export var auto_rotate: bool = true
@export var auto_rotation_speed: float = -1.5
@export var auto_rotate_time_in_seconds: float = 3.0

var _currently_auto_rotate: bool = false
var _timer: Timer = null
var _player_rotated: bool = false

func _ready() -> void:
	_currently_auto_rotate = auto_rotate
	if auto_rotate:
		_timer = Timer.new()
		add_child(_timer)
		_timer.one_shot = true
		_timer.timeout.connect(_timer_done)

func _process(delta: float) -> void:
	if _player_rotated:
		if not _timer.is_stopped():
			_timer.stop()
		_timer.start(auto_rotate_time_in_seconds)
		_player_rotated = false
		_currently_auto_rotate = false
		return
	_handle_auto_rotate(delta)

func disable() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	if _timer != null:
		_timer.stop()

func enable() -> void:
	process_mode = Node.PROCESS_MODE_INHERIT
	reset_object_rotation()
	_player_rotated = false
	_currently_auto_rotate = true

func _timer_done() -> void:
	_currently_auto_rotate = auto_rotate

func receive_player_rotate(delta: Vector3) -> void:
	_player_rotated = true
	rotate_y.emit(delta.y)
	rotate_x.emit(delta.x)
	rotate_z.emit(delta.z)


func _handle_auto_rotate(delta: float) -> void:
	if not _currently_auto_rotate:
		return
	rotate_y.emit(auto_rotation_speed * delta)

func reset_object_rotation() -> void:
	_player_rotated = true
	_currently_auto_rotate = false
	request_rotation.emit(Vector3.ZERO)
