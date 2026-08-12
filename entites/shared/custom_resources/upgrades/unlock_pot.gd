class_name UnlockPotAction extends UpgradeAction

var _game_data_system: GameDataSystem:
	get():
		if _game_data_system == null:
			_game_data_system = _systems.get_system("GameDataSystem")
		return _game_data_system

func can_execute() -> bool:
	var bought_upgrades: int = _game_data_system.get_item_count(_upgrade)
	if bought_upgrades > _upgrade.maximal_buyable_amount:
		return false
	return true

func execute() -> bool:
	if not can_execute():
		return false
	_upgrade_system.unlock_pot()
	return true
