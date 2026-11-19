@tool
class_name LanternGeneratorTool extends Node3D

#@export_tool_button("Rebuild") var action: Callable = _rebuild
@export var placeholder_template: PackedScene:
	set(value):
		_rebuild()
		if value == null:
			placeholder_template = null
			return
		placeholder_template = value
		

@export_range(0, 1000) var amount: int = 1:
	set(value):
		amount = value
		_rebuild()

@export_range(1, 1000, 0.1) var spacing: float = 1.0:
	set(value):
		spacing = value
		_rebuild()

@export var offset: float = 0:
	set(value):
		offset = value
		if generated == null:
			return
		generated.position.z = offset

@onready var generated: Node3D = Node3D.new()

func _ready() -> void:
	if not has_node("Generated"):
		generated.name = "Generated"
		add_child(generated)
		generated.owner = get_tree().edited_scene_root
		return
	generated.queue_free()
	generated = get_node("Generated")

func _rebuild() -> void:
	if generated == null:
		return
	for child: Node in generated.get_children():
		child.queue_free()
	if placeholder_template == null:
		return	

	var initial_spawn_point_z: float = 0
	for instance: int in amount:
		var template: Node3D = placeholder_template.instantiate()
		if template == null:
			push_error("Could not instantiate placeholder template: %s" % placeholder_template.resource_path)
			return
		template.position.z += initial_spawn_point_z
		template.name = "Generated %d" % instance
		template.set_meta("generated", true)
		initial_spawn_point_z += spacing

		generated.add_child(template)
		template.owner = get_tree().edited_scene_root

	generated.position.z = offset
