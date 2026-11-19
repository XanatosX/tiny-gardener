class_name ConditionControlledOmniLight extends OmniLight3D

@export var light_condition: LightCondition = null

@onready var _systems: Systems = $"/root/MainGame/%Systems"

func _ready() -> void:
	assert(_systems != null, "Missing system node")
	assert(light_condition != null, "Missing light condition")
	var day_time_system: DayNightCycleSystem = _systems.get_system("DayNightCycleSystem")
	assert(day_time_system != null, "Missing day night system")

	light_condition.init(day_time_system)
	day_time_system.day_time_changed.connect(_day_time_changed)

	_day_time_changed(day_time_system.get_current_day_time())

func _day_time_changed(day_time: DayNightCycleSystem.DayTime) -> void:
	if not is_node_ready():
		await ready
	visible = light_condition.is_active(day_time)
