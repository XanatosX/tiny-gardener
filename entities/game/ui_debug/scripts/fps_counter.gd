class_name FPSCounter extends Label

@export var number_format: String = "%3d"

func _process(_delta: float) -> void:
	text = number_format % Engine.get_frames_per_second()
