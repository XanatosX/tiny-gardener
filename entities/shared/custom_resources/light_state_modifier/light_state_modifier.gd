@abstract
class_name LightStateModifier extends Resource

@abstract func trigger(light: Light3D, new_state: bool) -> void

## Method to change the light behavior
func modify(_light: Light3D) -> void:
	pass