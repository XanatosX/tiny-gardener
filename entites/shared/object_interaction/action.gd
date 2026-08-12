@abstract class_name Action extends Resource

enum Type
{
	NONE,
	Plant,
	Harvest,
	Water,
	Fertilize,
	Trigger
}

@export var action_name: TextTranslation
@export var action_description: TextTranslation
@export var icon: Texture
@export var action_generator: SubActionGenerator = null
@export var allows_text_transform: bool = false

var type: Type
var updatable: bool = false

var _display_name_transform_method: Callable = func(translation: TextTranslation) -> String: return translation.get_text()
var _display_description_transform_method: Callable = func(translation: TextTranslation) -> String: return translation.get_text()

@abstract func controlled_node_has_valid_state(controlled_node: Node3D, systems: Systems) -> bool

@abstract func can_execute(controlled_node: Node3D, item: Item, systems: Systems) -> bool

@abstract func execute(controlled_node: Node3D, item: Item, systems: Systems) -> bool

func get_display_name() -> String:
	return _display_name_transform_method.call(action_name)
	
func get_description() -> String:
	return _display_description_transform_method.call(action_description)

## Callable will take a "TextTranslation" as argument and must return a String
func set_name_transform_method(method: Callable) -> void:
	if not _validate_transform_method(method):
		return
	_display_name_transform_method = method

## Callable will take a "TextTranslation" as argument and must return a String
func set_description_transform_method(method: Callable) -> void:
	if not _validate_transform_method(method):
		return
	_display_description_transform_method = method

func _validate_transform_method(method :Callable) -> bool:
	if not allows_text_transform or method.get_argument_count() < 1:
		return false
	return true