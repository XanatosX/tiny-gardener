class_name UiDynamicActionTemplate extends UIActionTemplate


signal sub_mode_active()
signal sub_mode_inactive()

@export var template: Node
@export var max_entries: int = 10
@export var action_generator: SubActionGenerator

var _game_state_system: GameDataSystem:
	get():
		if _game_state_system == null:
			_game_state_system = _systems.get_system("GameDataSystem")
		return _game_state_system

func _ready() -> void:
	assert(_systems != null, "Missing systems node")
	_sub_action_support = true
	super()

func setup(setup_action: Action) -> void:
	super(setup_action)
	
	assert(setup_action.action_generator != null, "Missing sub action generator")
	action_generator = setup_action.action_generator

func activate_sub_action_mode() -> void:
	_generate_sub_entries()
	_disable_if_no_sub_actions()
	super()
	if sub_actions.size() == 0: 
		disable_sub_action_mode()
		return
	sub_mode_active.emit()

func disable_sub_action_mode() -> void:
	sub_mode_inactive.emit()
	super()

func _generate_sub_entries() -> void:
	action_generator.generate_sub_entries(sub_actions, _game_state_system, self)

func _disable_if_no_sub_actions() -> void:
	if sub_actions.size() == 0:
		visible = false
		is_available = false

func get_action_template() -> UIActionTemplate:
	for action_template: UIActionTemplate in sub_actions:
		if not action_template.is_available:
			action_template.visible = true
			return action_template
	var placeholder: InstancePlaceholder = template as InstancePlaceholder
	var instance: UIActionTemplate = placeholder.create_instance() as UIActionTemplate
	sub_actions.append(instance)
	return instance

func rebuild_sub_actions() -> void:
	_generate_sub_entries()
	_disable_all_sub_actions()
	_disable_if_no_sub_actions()
	_sub_action_index = _get_first_sub_action()
	sub_actions[_sub_action_index].change_active(true)
