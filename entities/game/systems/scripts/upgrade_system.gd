class_name UpgradeSystem extends System

@export var pot_management_system: PotManagerSystem:
	get():
		if pot_management_system == null:
			pot_management_system = _systems.get_system("PotManagerSystem")
		return pot_management_system

func unlock_pot() -> void:
	pot_management_system.unlock_pot()
