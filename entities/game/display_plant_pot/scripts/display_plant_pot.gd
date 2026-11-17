@tool
class_name DisplayPlantPot extends Node3D

@export_tool_button("Update from resource") var update_action: Callable = _update_values
@export var display_resource: DisplayPlant = null:
	set(value):
		display_resource = value
		_update_values()

@export var billboard: bool = true:
	set(value):
		billboard = value
		_update_values()

@onready var plant: Sprite3D = $"%Plant"

func _ready() -> void:
	_update_values()

func _update_values() -> void:
	if plant == null:
		return
	plant.texture = display_resource.plant_texture
	plant.hframes = display_resource.rows
	plant.vframes = display_resource.columns
	plant.frame = display_resource.selected_frame
	plant.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	if billboard:
		plant.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
