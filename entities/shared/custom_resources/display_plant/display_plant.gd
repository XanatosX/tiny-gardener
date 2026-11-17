class_name DisplayPlant extends Resource

@export var plant_texture: Texture2D
@export_range(1, 100) var rows: int = 1
@export_range(1, 100)  var columns: int = 1
@export_range(0, 100)  var selected_frame: int = 0
