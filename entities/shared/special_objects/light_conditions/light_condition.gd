@abstract class_name LightCondition extends Resource

var _day_time_system: DayNightCycleSystem

func init(day_night_system: DayNightCycleSystem) -> void:
	_day_time_system = day_night_system

@abstract 
func is_active(day_time: DayNightCycleSystem.DayTime) -> bool