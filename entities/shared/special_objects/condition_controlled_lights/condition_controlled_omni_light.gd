class_name ConditionControlledOmniLight extends OmniLight3D

@export var light_condition: LightCondition = null
@export var light_modifier: LightStateModifier

@onready var _systems: Systems = $"/root/MainGame/%Systems"

var _logic: ConditionControlledLightLogic = ConditionControlledLightLogic.new()

func _ready() -> void:
	assert(_systems != null, "Missing system node")
	assert(light_condition != null, "Missing light condition")
	var day_time_system: DayNightCycleSystem = _systems.get_system("DayNightCycleSystem")
	assert(day_time_system != null, "Missing day night system")

	_logic.owner = self
	_logic.light_condition = light_condition
	_logic.light_modifier = light_modifier
	_logic.init(day_time_system)

func _process(_delta: float) -> void: 
	_logic._process()

func _day_time_changed(day_time: DayNightCycleSystem.DayTime) -> void:
	_logic._day_time_changed(day_time)
