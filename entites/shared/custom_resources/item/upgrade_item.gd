class_name UpgradeItem extends Item

@export var requirements: Array[UpgradeRequirements] = []
@export var upgrade_action: UpgradeAction = null
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

func init(systems: Systems) -> void:
	if _initialized:
		return
	_initialized = true
	assert(upgrade_action != null, "Missing upgrade action")
	assert(systems != null, "Missing systems init")
	_systems = systems
	upgrade_action.init(systems, self)
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
	return amount_valid and requirements_valid and upgrade_action.can_execute() 

func bought() -> void:
	activate()

func activate(times: int = 1) -> void:
	if not upgrade_action.can_execute():
		return
	for time: int in times:
		upgrade_action.execute()
