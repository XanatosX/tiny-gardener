@tool
class_name DynamicItemNodeTool extends Node3D

@export_tool_button("Refresh Representation") var refresh_representation: Callable = _add_representation
var systems: Systems:
	get():
		if _systems == null:
			_systems = $"/root/MainGame/%Systems"
		return _systems

var _systems: Systems

@export var item_representation: PackedScene = null


func _add_representation() -> void:
	if not is_inside_tree():
		push_warning("Not in tree just yet!")
		return
	for child: Node in get_children():
		if child.has_meta("Generated"):
			if child.get_meta("Generated"):
				child.queue_free()
	
	var tree: SceneTree = get_tree()
	if tree == null:
		return
	if tree.edited_scene_root == null:
		return
	if item_representation == null:
		return

	if not _additional_validation() or item_representation == null:
		push_warning("Either representation ist missing or an additional validation step failed!")
		return
	
	var representation: Node3D = item_representation.instantiate()
	if representation == null:
		push_error("Could not instantiate item representation: %s" % item_representation.resource_path)
		return
	representation.position = Vector3.ZERO
	representation.name = "ItemRepresentation"
	representation.set_meta("Generated", true)
	add_child(representation)
	representation.owner = get_tree().edited_scene_root

## Use this method to add your custom validation, return true if everything is valid
func _additional_validation() -> bool:
	return true