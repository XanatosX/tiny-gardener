class_name GameDataSystem extends System

signal item_amount_changed(item: Item, amount: int)
signal money_changed(amount: float)
signal money_delta_change(amount: float)

@export var max_storable_water: float = 250

@export_group("Debug")
@export var debug_seeds: Array[Item]
@export var debug_seed_count: int = 5

var game_data: GameData = null

func _ready() -> void:
	super()
	game_data = GameData.new()
	tree_exited.connect(_unregister_commands)
	_register_commands()

func _register_commands() -> void:
	Console.register_command(Command.create("give_money")
									.calling_method(_console_add_money)
									.with_argument(CommandArgument.create("amount")
									                              .of_type(CommandArgument.Type.FLOAT)
																  .with_description("The amount of money to add")
																  .finalize()
									)
									.documentation()
									.with_description("Add money to bank account")
									.finish())

func _unregister_commands() -> void:
	Console.remove_command("give_money")

func add_multiple_items(data: Dictionary[Item, int]) -> void:
	for item: Item in data:
		item_amount_changed.emit(item, data.get(item))
		game_data.add_item(item, data.get(item))

func _console_add_money(amount: float) -> void:
	change_money(amount)

func add_item(type: Item, amount: int) -> void:
	game_data.add_item(type, amount)
	item_amount_changed.emit(type, amount)

func use_item(type: Item, amount: int = 1) -> bool:
	if get_item_count(type) <= 0:
		return false
	if game_data.remove_item(type):
		item_amount_changed.emit(type, -amount)
		return true
	return false

func get_item_count(type: Item) -> int:
	assert(type != null, "Type should never be null")
	return game_data.get_item_amount(type)

func has_item(type: Item) -> bool:
	return get_item_count(type) > 0

func get_items() -> Array[Item]:
	return game_data.get_items()

func get_available_seeds() -> Array[PlantData]:
	return game_data.get_seeds()

func get_available_fertilizer() -> Array[Fertilizer]:
	return game_data.get_fertilizer()

func add_plant_drop(drop: Dictionary[PlantDrop, int]) -> void:
	for plant_drop: PlantDrop in drop:
		item_amount_changed.emit(plant_drop, drop.get(plant_drop))
		game_data.add_item(plant_drop, drop.get(plant_drop))
	money_delta_change.emit(game_data.sell_plant_drops())
	money_changed.emit(game_data.get_money())

func sell_item(item_to_sell: Item, amount: int) -> float:
	var income: float = game_data.sell_item(item_to_sell, amount)
	money_delta_change.emit(income)
	money_changed.emit(game_data.get_money())
	return income

func get_money() -> float:
	return game_data.get_money()

func get_water() -> float:
	return game_data.get_water()

func add_water(amount: float) -> void:
	game_data.fill_water(amount, max_storable_water)

func change_money(change_amount: float) -> bool:
	if change_amount == 0:
		return true
	var result: bool = game_data.change_money(change_amount)
	if result:
		money_changed.emit(game_data.get_money())
		money_delta_change.emit(change_amount)
	return result

func game_loaded(save: SaveGame) -> void:
	game_data = save.game_data
	for item: Item in game_data.get_items():
		if item is UpgradeItem:
			item.init(_systems)
			_run_upgrade_on_load(item)
	money_changed.emit(game_data.money)

func _run_upgrade_on_load(upgrade: UpgradeItem) -> void:
	if not upgrade.execute_on_load:
		return
	assert(upgrade.is_valid(), "Upgrade %s not valid after loading!" % upgrade.get_display_name())
	for execution: int in game_data.get_item_amount(upgrade):
		upgrade.activate()