class_name InventoryUpdatedTrigger extends SituationTrigger

@export var specific_watched_item: Item = null

var _systems: Systems:
	get():
		if _systems == null:
			_systems = $"/root/MainGame/Systems"
		return _systems

var _game_data_system: GameDataSystem:
	get():
		if _game_data_system == null:
			_game_data_system = _systems.get_system("GameDataSystem")
		return _game_data_system

func _ready() -> void:
	_game_data_system.item_amount_changed.connect(_items_changed)

func _items_changed(item: Item, _amount: int) -> void: 
	if not specific_watched_item == null:
		if not item.is_identically(specific_watched_item):
			return

	trigger.emit()
	

