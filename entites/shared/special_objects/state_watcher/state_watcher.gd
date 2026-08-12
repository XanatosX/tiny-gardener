@abstract class_name StateWatcher extends Node

@onready var state: DeviceState = $"%DeviceState"

func _ready() -> void:
	assert(state != null, "Missing device state")