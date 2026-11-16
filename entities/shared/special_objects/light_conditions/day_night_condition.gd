class_name DayNightCondition extends LightCondition

@export_flags("Morning", "Midday", "Evening", "Midnight") var active_day_times: int = 8

func is_active(day_time: DayNightCycleSystem.DayTime) -> bool:
	var active: bool = false
	
	match day_time:
		DayNightCycleSystem.DayTime.SUNRISE:
			active = (active_day_times & 1) != 0
		DayNightCycleSystem.DayTime.MIDDAY:
			active = (active_day_times & 2) != 0
		DayNightCycleSystem.DayTime.SUNSET:
			active = (active_day_times & 4) != 0
		DayNightCycleSystem.DayTime.MIDNIGHT:
			active = (active_day_times & 8) != 0
		_:
			active = false

	return active