class_name GraphicSettings extends Resource

@export var menu_max_fps: int = 60
@export var ingame_max_fps: int = 120
@export var vsync: DisplayServer.VSyncMode = DisplayServer.VSyncMode.VSYNC_ADAPTIVE
@export_range(1, 3, 1) var pixelation: int = 3:
	set(value):
		pixelation = clampi(value, 1, 3)
