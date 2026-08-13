@abstract class_name TickDependentSystem extends System

var auto_disconnect_after_tick_system_found: bool = true

func _ready() -> void:
	super()
	_connect_systems()

func _connect_systems() -> void:
	var tick_system: System = get_systems().get_system("TickSystem")
	if tick_system == null or tick_system is not TickSystem:
		print_debug("Late register")
		get_systems().system_registered.connect(_system_registered)
		return
	_connect_tick_system(tick_system as TickSystem)

func _system_registered(_system_name: String, system: System) -> void:
	if system is TickSystem:
		if auto_disconnect_after_tick_system_found:
			get_systems().system_registered.disconnect(_system_registered)
		_connect_tick_system(system)

func _connect_tick_system(tick_system: TickSystem) -> void:
	tick_system.tick.connect(_on_tick)

@abstract func _on_tick() -> void