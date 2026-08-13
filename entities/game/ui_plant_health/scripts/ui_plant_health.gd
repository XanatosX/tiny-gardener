class_name UIPlantHealth extends Control

signal update_max_nutrition(new_value: float)
signal update_nutrition(new_value: float)

signal update_max_water(new_value: float)
signal update_water(new_value: float)

signal update_plant_name(plant_name: String)

@export var no_plant_name: TextTranslation = null

var _tracked_pot: PotVisuals = null

func _init() -> void:
	visible = false

func show_pot_data(pot: PotVisuals) -> void:
	assert(pot != null, "Pot should never be null!")
	if pot != _tracked_pot:
		_disconnect_pot()
	_tracked_pot = pot
	if not _tracked_pot.set_data.is_connected(_data_updated):
		_tracked_pot.set_data.connect(_data_updated)
	
	_communicate_plant_name(pot)
	update_max_nutrition.emit(pot.pot.max_nutrition)
	update_max_water.emit(pot.pot.max_water_level)
	update_water.emit(pot.pot.water_level)
	update_nutrition.emit(pot.pot.nutrition)
	show()

func hide_ui() -> void:
	_disconnect_pot()
	_tracked_pot = null
	hide()

func _disconnect_pot() -> void:
	if _tracked_pot == null:
		return
	
	_tracked_pot.set_data.disconnect(_data_updated)

func _data_updated(plant_data: PlantData) -> void:
	if plant_data == null:
		return
	update_plant_name.emit(plant_data.display_name.get_text())

func _communicate_plant_name(pot: PotVisuals) -> void:
	if not pot.plant_alive():
		update_plant_name.emit(no_plant_name.get_text())
		return
	_data_updated(pot.pot.plant_data)

func _process(_delta: float) -> void:
	if _tracked_pot == null or _tracked_pot.pot == null:
		return
	update_water.emit(_tracked_pot.pot.water_level)
	update_nutrition.emit(_tracked_pot.pot.nutrition)
