class_name UpgradeItem extends Item

@export var requirements: Array[UpgradeRequirements] = []
@export var no_actions_wanted: bool = false
@export var execute_on_load: bool = false
@export var upgrade_actions: Array[UpgradeAction] = []
## Defines how much more money each level will cost, this is  calculated by taking the base cost 
## times the modifier, this is then multiplied with the base amount
@export var price_modifier_per_level: float = 0
@export var has_max_amount: bool = false
@export var maximal_buyable_amount: int = 1

var _initialized: bool = false
var _systems: Systems
var _game_data_system: GameDataSystem:
	get():
		if _game_data_system == null and not _systems == null:
			_game_data_system = _systems.get_system("GameDataSystem")
		return _game_data_system

func _init() -> void:
	can_buy = false
	can_sell = false
	quality = Item.QUALITY.NONE
	show_quality_in_name = false

func init(systems: Systems) -> void:
	if _initialized:
		return
	_initialized = true
	if not no_actions_wanted:
		assert(not upgrade_actions.is_empty(), "Missing upgrade action")
	assert(systems != null, "Missing systems init")
	_systems = systems
	for action: UpgradeAction in upgrade_actions:
		action.init(systems, self)
	pass

func _get_bought_amount() -> int:
	return _game_data_system.get_item_count(self)

func _get_price_modifier() -> float:
	return _get_bought_amount() * price_modifier_per_level

func get_price() -> float:
	return super() + super() * _get_price_modifier()

func is_valid() -> bool:
	var requirements_valid: bool = true
	for requirement: UpgradeRequirements in requirements:
		if _game_data_system.get_item_count(requirement.upgrade) < requirement.amount:
			requirements_valid = false
	var amount_valid: bool = not has_max_amount or _game_data_system.get_item_count(self) < maximal_buyable_amount
	return amount_valid and requirements_valid and _validate_actions()

func _validate_actions() -> bool:
	if no_actions_wanted and upgrade_actions.is_empty():
		return true
	return upgrade_actions.any(func(action: UpgradeAction) -> bool: return action.can_execute())

func bought() -> void:
	activate()

func activate(times: int = 1) -> void:
	if not _validate_actions():
		return
	for action: UpgradeAction in upgrade_actions:
		for time: int in times:
			action.execute()
