class_name ConditionControlledLightLogic extends RefCounted

var owner: Node3D
var light_condition: LightCondition
var light_modifier: LightStateModifier

var _initial: bool = true

func init(day_time_system: DayNightCycleSystem) -> void:
	assert(owner != null, "Missing owner")
	assert(light_condition != null, "Missing light condition")

	if light_modifier != null:
		light_modifier = light_modifier.duplicate_deep()

	light_condition.init(day_time_system)
	day_time_system.day_time_changed.connect(_day_time_changed)

	owner.visible = false
	_day_time_changed(day_time_system.get_current_day_time())
	_initial = false

func _process() -> void:
	if light_modifier == null:
		return
	light_modifier.modify(owner)

func _day_time_changed(day_time: DayNightCycleSystem.DayTime) -> void:
	if not owner.is_node_ready():
		await owner.ready
	if _initial or light_modifier == null:
		owner.visible = light_condition.is_active(day_time)
		return
	light_modifier.trigger(owner, light_condition.is_active(day_time))