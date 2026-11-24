class_name PlantDrop extends Item

func is_identically(item: Item) -> bool:
	return display_name.key == item.display_name.key \
			and _check_quality(item) \
			and price == item.price \
			and sell_modifier == item.sell_modifier

func _check_quality(item: Item) -> bool:
	if item.quality == Item.QUALITY.NONE:
		return true
	return quality == item.quality