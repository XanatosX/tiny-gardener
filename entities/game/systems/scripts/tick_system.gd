class_name TickSystem extends System

signal tick()

@export var tick_interval: float = 0.5

var _tick_timer: float = 0.0

func _init() -> void:
	Console.register_command(Command.create("set_tick_rate")
									.calling_method(_set_tick_rate)
									.with_argument(CommandArgument.create("rate")
																  .of_type(CommandArgument.Type.FLOAT)
																  .with_predefined_value(0.5)
																   .with_predefined_value(0.05)
																   .with_predefined_value(0.01)
																   .with_predefined_value(1.0)
																   .with_description("The new tick rate, 0.5 is default")
																   .finalize()).documentation().with_description("Change the tick rate, to slow down or speed up the simulation")
																   .finalize())
	Console.register_command(Command.create("get_tick_rate")
									.calling_method(_get_tick_rate)
									.documentation()
									.with_description("Get the current tick rate")
									.finalize())

func _process(delta: float) -> void:
	_tick_timer += delta
	if _tick_timer > tick_interval:
		_tick_timer = _tick_timer - tick_interval
		tick.emit()

func _get_tick_rate() -> String:
	return str(tick_interval)

func _set_tick_rate(interval: float) -> String:
	tick_interval = interval
	return "tick rate set to %f" % tick_interval

func _unloading() -> void:
	if Console.command_name_is_registered("set_tick_rate"):
		Console.remove_command("set_tick_rate")
	if Console.command_name_is_registered("get_tick_rate"):
		Console.remove_command("get_tick_rate")
