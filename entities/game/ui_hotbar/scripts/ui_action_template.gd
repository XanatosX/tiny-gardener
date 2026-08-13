class_name UIActionTemplate extends TextureRect

signal update_action_name(name: String)
signal update_action_description(name: String)
signal update_quality(texture: Texture)

@export var action_name: TextTranslation
@export var action_description: TextTranslation
@export var action_icon: Texture
@export var action: Action.Type
@export var item: Item

@export var sub_actions: Array[UIActionTemplate]
var is_available: bool = true

var _sub_action_index: int = 0
var _sub_action_mode: bool = false
var _sub_action_support: bool = false

var _display_name: String
var _description: String

var _systems: Systems:
	get():
		if _systems == null:
			_systems = $"/root/MainGame/%Systems"
		return _systems

func _ready() -> void:
	init()
	offset_transform_enabled = true

func setup(setup_action: Action) -> void:
	_display_name = setup_action.get_display_name()
	_description = setup_action.get_description()
	action_name = setup_action.action_name
	action_description = setup_action.action_description
	action_icon = setup_action.icon
	action = setup_action.type

	init()

func init() -> void:
	if action_name != null and _display_name.length() == 0:
		_display_name = action_name.get_text()
	update_action_name.emit(_display_name)

	if action_description != null and _description.length() == 0:
		_description = action_description.get_text()
	update_action_description.emit(_description)

	if item != null:
		action_icon = item.icon
		update_quality.emit(item.get_quality_icon())
	texture = action_icon
	disable_sub_action_mode()

func change_active(new_state: bool) -> void:
	var tween: Tween = create_tween()
	var target_size: Vector2 = Vector2.ONE
	if new_state:
		target_size *= 1.5
	tween.tween_property(self, "offset_transform_scale", target_size, 0.2)

func has_sub_action_support() -> bool:
	return _sub_action_support

func has_sub_actions() -> bool:
	return sub_actions.filter(func(sub_action: UIActionTemplate) -> bool: return sub_action.is_available).size() > 0

func activate_sub_action_mode() -> void:
	_disable_all_sub_actions()
	_sub_action_index = _get_first_sub_action()
	if sub_actions.size() == 0:
		return
	
	sub_actions[_sub_action_index].change_active(true)
	_sub_action_mode = true

func is_in_sub_action_mode() -> bool:
	return _sub_action_mode

func _disable_all_sub_actions() -> void:
	for sub_action: UIActionTemplate in sub_actions:
		sub_action.change_active(false)

func next_sub_action() -> void:
	_disable_all_sub_actions()
	var found: bool = false
	for i: int in sub_actions.size():
		var index: int = _sub_action_index + i + 1
		if index >= sub_actions.size():
			break
		var current_action: UIActionTemplate = sub_actions[index]
		if current_action.is_available:
			_sub_action_index = index
			sub_actions[_sub_action_index].change_active(true)
			found = true
	
	if not found:
		disable_sub_action_mode()

func previous_sub_action() -> void:
	_disable_all_sub_actions()
	var found: bool = false
	for i: int in sub_actions.size():
		var index: int = _sub_action_index - (i + 1)
		if index < 0:
			break
		var current_action: UIActionTemplate = sub_actions[index]
		if current_action.is_available:
			_sub_action_index = index
			sub_actions[_sub_action_index].change_active(true)
			found = true

	if not found:
		disable_sub_action_mode()

func disable_sub_action_mode() -> void:
	_sub_action_mode = false

func rebuild_sub_actions() -> void:
	pass

func _get_first_sub_action() -> int:
	for i: int in sub_actions.size():
		if sub_actions[i].is_available:
			return i
	return 0

func get_action_item() -> Item:
	if is_in_sub_action_mode():
		return sub_actions[_sub_action_index].get_action_item()
	return item
