class_name GameUI extends Control

signal _show_pot_data(pot: PotVisuals)
signal trigger_action(type: Action.Type, item: Item)
signal _hide_pot_data()
signal money_changed(amount: float)
signal delta_money_changed(amount: float)
signal show_item_off(item: Item, amount: int)
signal available_actions(actions: Array[Action])

signal dialog_start()
signal dialog_end()

signal game_saving()
signal saving_done()

func show_pot_data(pot: PotVisuals) -> void:
	_show_pot_data.emit(pot)

func hide_pot_data() -> void:
	_hide_pot_data.emit()

func forward_trigger_action(type: Action.Type, item: Item) -> void:
	trigger_action.emit(type, item)

func update_money(amount: float) -> void:
	money_changed.emit(amount)

func money_delta_change(amount: float) -> void:
	delta_money_changed.emit(amount)

func show_item(item: Item, amount: int) -> void:
	show_item_off.emit(item, amount)

func actions_update(actions: Array[Action]) -> void:
	available_actions.emit(actions)

func dialog_started() -> void:
	dialog_start.emit()

func dialog_ended() -> void:
	dialog_end.emit()

func game_is_saving() -> void:
	game_saving.emit()

func game_has_saved() -> void:
	saving_done.emit()