class_name DayNightCycle extends Node3D

@export var percentage_offset: float = 0.0

@onready var sun: Sun = $"%Sun"

func percentage_update(percentage: float) -> void:
	if not self.is_node_ready():
		await self.ready
	var real_percentage: float = percentage + percentage_offset
	if real_percentage > 1.0:
		real_percentage = real_percentage - 1.0

	var rotation_deg: float = real_percentage * 360
	sun.set_new_rotation(rotation_deg)
