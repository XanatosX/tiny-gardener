class_name DayTimeControlledOmniLight extends OmniLight3D

@export_flags("Morning", "Midday", "Evening", "Midnight") var active_day_times: int = 8

@onready var _systems: Systems = $"/root/MainGame/%Systems"


func _ready() -> void:
	assert(_systems != null, "Missing system node")
	var day_time_system: DayNightCycleSystem = _systems.get_system("DayNightCycleSystem")
	assert(day_time_system != null, "Missing day night system")
	day_time_system.day_time_changed.connect(_day_time_changed)
	visible = false

func _day_time_changed(day_time: DayNightCycleSystem.DayTime) -> void:
	if not is_node_ready():
		await ready
	var is_active: bool = false
	
	match day_time:
		DayNightCycleSystem.DayTime.SUNRISE:
			is_active = (active_day_times & 1) != 0
		DayNightCycleSystem.DayTime.MIDDAY:
			is_active = (active_day_times & 2) != 0
		DayNightCycleSystem.DayTime.SUNSET:
			is_active = (active_day_times & 4) != 0
		DayNightCycleSystem.DayTime.MIDNIGHT:
			is_active = (active_day_times & 8) != 0
		_:
			is_active = false

	visible = is_active
