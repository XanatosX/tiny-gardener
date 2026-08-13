class_name TickSystem extends System

signal tick()

@export var tick_interval: float = 0.5

var _tick_timer: float = 0.0

func _process(delta: float) -> void:
	_tick_timer += delta
	if _tick_timer > tick_interval:
		_tick_timer = _tick_timer - tick_interval
		tick.emit()