class_name PlantSprite extends Sprite3D

func set_data(plant_data: PlantData) -> void:
	if plant_data == null:
		clean()
		return
	clean()
	texture = plant_data.texture
	flip_h = randi_range(0, 1) == 1
	hframes = plant_data.grow_stages
	set_grow_stage(0)

func set_grow_stage(stage: int) -> void:
	frame = clampi(stage, 0, hframes - 1)

func clean() -> void:
	texture = null
	hframes = 1
	vframes = 1
	frame = 0
