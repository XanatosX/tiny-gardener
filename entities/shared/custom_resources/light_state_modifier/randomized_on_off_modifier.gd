class_name RandomizedOnOffModifier extends LightStateModifier

## The min seconds to randomize the on or off time
@export_range(0, 5, 0.01) var min_on_off_state_randomizer: float = 0
## The max seconds to randomize the on or off time
@export_range(0.5, 5, 0.01) var max_on_off_state_randomizer: float = 0.5

var _number_generated: bool = false
var _random_number: float = 0

func trigger(light: Light3D, new_state: bool) -> void:
	if light.visible == new_state:
		return
	await light.get_tree().create_timer(_get_random_number()).timeout
	light.visible = new_state

func _get_random_number() -> float:
	if _number_generated:
		return _random_number
	_random_number = randf_range(min_on_off_state_randomizer, max_on_off_state_randomizer)
	_number_generated = true
	return _get_random_number()