class_name UIHotbar extends Control

signal trigger_action(type: Action.Type, item: Item)

@export var debug_plant: PlantData = null
@export var actions_node: Node = null
@export var simple_action_template: Node = null
@export var dynamic_action_template: Node = null

var _actions: Array[UIActionTemplate] = []
var _action_index: int = 0

var _can_interact: bool = true

func _ready() -> void:
	assert(actions_node != null, "Missing actions node")
	assert(simple_action_template != null, "Missing simple action template")
	assert(simple_action_template is InstancePlaceholder, "Is not a instance placeholder")
	assert(dynamic_action_template != null, "Missing dynamic action template")
	assert(dynamic_action_template is InstancePlaceholder, "Is not a instance placeholder")
	for node: Node in actions_node.get_children():
		if node is UIActionTemplate:
			_actions.append(node)

	if _actions.size() == 0:
		visible = false
		return
	_actions[_action_index].change_active(true)
	available_actions_changed([])

func available_actions_changed(actions: Array[Action.Type]) -> void:
	var any_active: bool = false
	for action_template: UIActionTemplate in _actions:
		var active: bool = false
		if action_template.has_sub_action_support():
			action_template.disable_sub_action_mode()
		if actions.has(action_template.action):
			active = true
			any_active = true
		
		action_template.is_available = active
		action_template.visible = active

	visible = any_active
	for action: UIActionTemplate in _actions:
		_actions[_action_index].change_active(false)
	_action_index = _get_first_available_action()
	if _actions.size() == 0:
		visible = false
		return
	visible = true
	_actions[_action_index].change_active(true)

func actions_changed(actions: Array[Action]) -> void:
	get_child(0).visible = actions.size() > 0
	var types: Array[Action.Type] = []
	var missing_actions: Array[Action] = []
	for action: Action in actions:
		var result: int = _actions.find_custom(func(c_action: UIActionTemplate) -> bool: return c_action.action == action.type)
		if result == -1:
			missing_actions.append(action)
		types.append(action.type)

	_add_missing_ui_buttons(missing_actions)
	_update_ui_buttons(actions)
	if missing_actions.size() > 0:
		_order_ui_buttons()
	available_actions_changed(types)

func _add_missing_ui_buttons(missing: Array[Action]) -> void:
	for action: Action in missing:
		var instance_template: InstancePlaceholder = simple_action_template as InstancePlaceholder
		if action.action_generator != null:
			instance_template = dynamic_action_template as InstancePlaceholder
		
		if instance_template == null:
			return
		var ui_template: UIActionTemplate = instance_template.create_instance()
		ui_template.setup(action)
		_actions.append(ui_template)


func _update_ui_buttons(actions: Array[Action]) -> void:
	for action: Action in actions:
		if not action.updatable:
			continue
		var template: UIActionTemplate = _find_matching_action(action.type)
		if template == null:
			continue
		template.setup(action)

func _find_matching_action(type: Action.Type) -> UIActionTemplate:
	for template: UIActionTemplate in _actions:
		if template.action == type:
			return template
	return null

func _order_ui_buttons() -> void:
	for child: Node in actions_node.get_children():
		if child is UIActionTemplate:
			var index: int = child.action
			## @TODO fix issue with move child, sometimes the index is larger than
			## The number of available positions, this need to be fixed!
			actions_node.move_child(child, index)

func _process(_delta: float) -> void:
	if _actions.size() == 0 or not _can_interact:
		return
	var _index_changed: bool = false
	var current_action: UIActionTemplate = _actions[_action_index]
	if Input.is_action_just_pressed("interact"):
		_enter_sub_action_or_trigger(current_action)
	
	if Input.is_action_just_pressed("next_action_slot"):
		if current_action.is_available and current_action.is_in_sub_action_mode():
			current_action.next_sub_action()
			if current_action.is_in_sub_action_mode():
				return
		current_action.change_active(false)
		_action_index = get_next_action_index()
		_index_changed = true
	if Input.is_action_just_pressed("previous_action_slot"):
		if current_action.is_available and current_action.is_in_sub_action_mode():
			current_action.previous_sub_action()
			if current_action.is_in_sub_action_mode():
				return
		current_action.change_active(false)
		_action_index = get_previous_action_index()
		_index_changed = true

	if not _index_changed:
		return
	if _action_index >= _actions.size():
		_action_index = 0
	if _action_index < 0:
		_action_index = _actions.size() - 1

	_actions[_action_index].change_active(true)

func toggle_can_interact(new_state: bool) -> void:
	_can_interact = new_state

func disable_interaction() -> void:
	toggle_can_interact(false)

func enable_interaction() -> void:
	toggle_can_interact(true)

func _get_first_available_action() -> int:
	var index: int = 0
	for action: UIActionTemplate in _actions:
		if action.is_available:
			return index
		index += 1
	return 0

func get_next_action_index() -> int:
	var temp_index: int = _action_index
	for i: int in _actions.size():
		temp_index = _action_index + i + 1
		if temp_index >= _actions.size():
			temp_index = absi(_actions.size() - temp_index)
		if _actions[temp_index].is_available:
			return temp_index
	return  _get_first_available_action()

func get_previous_action_index() -> int:
	var temp_index: int = _action_index
	for i: int in _actions.size():
		temp_index = _action_index - (i + 1)
		if temp_index < 0:
			temp_index = _actions.size() - absi(temp_index)
		if _actions[temp_index].is_available:
			return temp_index
	return _get_first_available_action()

func _enter_sub_action_or_trigger(action: UIActionTemplate) -> void:
	if not action.is_available:
		return
	if action.has_sub_action_support() and not action.is_in_sub_action_mode():
		action.activate_sub_action_mode()
		if not action.has_sub_actions():
			action.disable_sub_action_mode()
		return
	
	trigger_action.emit(action.action, action.get_action_item())
	action.rebuild_sub_actions()
