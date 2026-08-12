@abstract class_name System extends Node

var _systems: Systems

func _ready() -> void:
	var systems_node: Node = $"%Systems"
	assert(systems_node != null, "Missing systems node!")

	if systems_node is Systems:
		_systems = systems_node
		systems_node.register_system(name, self)

	assert(get_systems() != null, "Missing stored systems")

func get_systems() -> Systems:
	return _systems