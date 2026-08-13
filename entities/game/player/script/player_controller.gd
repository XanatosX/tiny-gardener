class_name PlayerController extends CharacterBody3D

signal target_reached()
signal movement_state_changed(new_state: bool)

@export var gravity_acceleration: float = 50
@export var movement_speed: float = 50.0

var moving: bool = false

var _pivot: Node3D
var _systems: Systems:
	get():
		if _systems == null:
			_systems = $"%Systems"
			assert(_systems != null, "No system found")
		return _systems
var _game_data_system: GameDataSystem:
	get():
		if _game_data_system == null:
			_game_data_system = _systems.get_system("GameDataSystem")
		return _game_data_system

var _can_move: bool = true
var _target_set: bool = false
var _target: Vector3 = Vector3.ZERO

func _ready() -> void:
	_pivot = $"%CameraPivot"
	if _pivot == null:
		_pivot = self

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	_handle_auto_mode(delta)

func _handle_auto_mode(delta: float) -> void:
	if not _target_set or not can_move_automatically():
		return
	var direction: Vector3 = global_position.direction_to(_target)
	direction.y = 0
	#_pivot.global_transform.basis * 
	velocity = direction.normalized() * movement_speed * delta
	move_and_slide()

	var player_pos: Vector2 = Vector2(global_position.x, global_position.z)
	var target_pos: Vector2 = Vector2(_target.x, _target.z)
	var distance: float = player_pos.distance_to(target_pos)
	if distance < 0.15:
		_target_set = false
		_target = Vector3.ZERO
		target_reached.emit()

func _handle_movement(delta: float) -> void:
	if not _can_move:
		return
	var z_axis: float = Input.get_axis("forward", "backward")
	var x_axis: float = Input.get_axis("left", "right")

	var gravity: float = 0.0
	if not is_on_floor():
		gravity = gravity_acceleration * delta
		z_axis = 0
		x_axis = 0
	var direction: Vector3 = Vector3(x_axis, -gravity, z_axis).normalized()
	
	velocity = _pivot.global_transform.basis * direction * movement_speed * delta
	move_and_slide()

func game_loaded(save: SaveGame) -> void:
	global_position = save.player_position

func toggle_movement(new_state: bool) -> void:
	velocity = Vector3.ZERO
	_can_move = new_state
	movement_state_changed.emit(new_state)

func disable_movement() -> void:
	toggle_movement(false)

func enable_movement() -> void:
	toggle_movement(true)

func can_move_automatically() -> bool:
	return not _can_move

func move_to_node(node: Node3D) -> void:
	move_to_global_position(node.global_position)

func move_to_global_position(target_position: Vector3) -> void:
	if not can_move_automatically():
		return
	
	_target_set = true
	_target = target_position

