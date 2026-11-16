class_name AndLightCondition extends LightCondition

@export var conditions: Array[LightCondition] = []

func init(day_night_system: DayNightCycleSystem) -> void:
	if conditions.size() == 0:
		push_warning("Missing conditions for and light condition, this will always default to true")
	for condition: LightCondition in conditions:
		condition.init(day_night_system)

func is_active(day_time: DayNightCycleSystem.DayTime) -> bool:
	for condition: LightCondition in conditions:
		if not condition.is_active(day_time):
			return false
	return true
