extends Node3D

## If set to false, the object will be deleted instead
@export var hide_only: bool = true

func _ready() -> void:
	visible = false
	if not hide_only:
		queue_free()