@abstract class_name UpgradeAction extends Resource

var _systems: Systems
var _upgrade: UpgradeItem

var _initialized: bool = false

var _upgrade_system: UpgradeSystem:
	get():
		if _upgrade_system == null:
			_upgrade_system = _systems.get_system("UpgradeSystem")
		return _upgrade_system

func init(systems: Systems, upgrade: UpgradeItem) -> void:
	if _initialized:
		return
	_initialized = true
	_upgrade = upgrade
	_systems = systems

@abstract func can_execute() -> bool

@abstract func execute() -> bool

