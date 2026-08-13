class_name GrowthSystem extends TickDependentSystem

var _tracked_pots: Dictionary[int, Pot] = {}

func _on_tick() -> void:
	for pot: Pot in _tracked_pots.values():
		if not pot.has_plant() or not pot.is_active():
			continue
		var growth_points: float = pot.get_water_modifier() * pot.get_nutrition_modifier()
		pot.growth_plant(growth_points)

func register_pot(index: int, pot: Pot) -> void:
	if _tracked_pots.has(index):
		return
	_tracked_pots.set(index, pot)

func replace_pot(index:int, pot: Pot) -> void:
	if _tracked_pots.has(index):
		_tracked_pots.set(index, pot)