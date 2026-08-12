class_name DataProgress extends Control

signal progress_icon_changed(texture: Texture)
signal max_value_changed(new_value: float)
signal value_changed(new_value: float)

@export var texture: Texture:
	set(value):
		_texture = value
		progress_icon_changed.emit(_texture)
	get():
		return _texture

var _texture: Texture

func change_max_value(new_value: float) -> void:
	max_value_changed.emit(new_value)

func change_value(new_value: float) -> void:
	value_changed.emit(new_value)