class_name CameraFacingSprite extends Sprite3D

@export var face_x: bool = false
@export var face_y: bool = false
@export var face_z: bool = false

var _camera: Camera3D:
	get():
		if _camera == null:
			_camera = get_viewport().get_camera_3d()
		return _camera

func _process(_delta: float) -> void:
	var initial_rotation: Vector3 = rotation
	look_at(_camera.global_position)
	if not face_x:
		rotation.x = initial_rotation.x
	if not face_y:
		rotation.y = initial_rotation.y
	if not face_z:
		rotation.z = initial_rotation.z
