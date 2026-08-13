class_name DynamicItemHandbookProvider extends DynamicHandbookEntry

@export var scene_template: PackedScene

func get_dynamic_entries() -> Dictionary[HandbookEntry.Group, Array]:
	var return_data: Dictionary[HandbookEntry.Group, Array] = {}
	var items: Array[Item] = ItemService.get_all_items()
	items.sort_custom(_custom_sort)
	for item: Item in items:
		var entry: ItemHandbookEntry = ItemHandbookEntry.new()
		entry.identifier = HandbookEntryIdentifier.new()
		entry.identifier.key = "%s_%s" % [item.display_name.key, Item.QUALITY.keys()[item.quality]]
		entry.set_display_name_overwrite(item.get_display_name())
		entry.icon = item.icon
		entry.group = _get_group_of_item(item)
		entry.item_reference = weakref(item)

		entry.scene_template = scene_template
		if return_data.has(entry.group):
			return_data[entry.group].append(entry)
			continue
		return_data.set(entry.group, [entry])

	return return_data

func _get_group_of_item(item: Item) -> HandbookEntry.Group:
	var return_group: HandbookEntry.Group = HandbookEntry.Group.ITEMS
	if item is UpgradeItem:
		return_group = HandbookEntry.Group.UPGRADES
	if item is PlantData:
		return_group = HandbookEntry.Group.PLANTS
	if item is PlantDrop:
		return_group = HandbookEntry.Group.DROPS
	if item is Fertilizer:
		return_group = HandbookEntry.Group.FERTILIZER

	return return_group

func _custom_sort(a: Item, b: Item) -> bool:
	if a.display_name.get_text() == b.display_name.get_text():
		return a.quality < b.quality
	return a.get_display_name() < b.get_display_name()
