@tool
class_name FrostedGlassControlPanel extends PanelContainer

@export var replace_material: Material = preload("res://assets/resources/materials/frosted_ui_material.tres"):
	set(value):
		material = value
		replace_material = value
	get():
		return replace_material

func _ready() -> void:
	## force set the material to ensure it set on loading
	if Engine.is_editor_hint() and replace_material != null:
		replace_material = replace_material