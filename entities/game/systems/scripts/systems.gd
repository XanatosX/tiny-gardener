class_name Systems extends Node

signal system_registered(name: String, system: System)

var _systems: Dictionary[String, System]

func register_system(system_name: String, system: System) -> bool:
	if _systems.has(system_name):
		return false
	if system == null:
		return false
	_systems.set(system_name, system)
	system_registered.emit(system_name, get_system(system_name))
	return true

func get_system(system_name: String) -> System:
	return _systems.get(system_name)

func get_system_names() -> Array[String]:
	return _systems.keys()
