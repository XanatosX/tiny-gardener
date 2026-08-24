class_name HandbookEntries extends Tree

const base_path: String = "res://assets/resources/handbook"

@export var handbook_ui: UiHandbook

@export_group("Scanning")
@export var scan_depth: int = 2
@export var max_entry_icon_size: int = 32

@export_group("Dynamic Providers")
@export var dynamic_entry_provider: Array[DynamicHandbookEntry]

@export_group("Visual and Translation")
@export var handbook_translation: TextTranslation
@export var translations: Dictionary[HandbookEntry.Group, TextTranslation] = {}
@export var group_icons: Dictionary[HandbookEntry.Group, Texture2D] = {}

@export_group("Ordering")
@export var ordered_groups: Array[HandbookEntry.Group] = [
	HandbookEntry.Group.GAME_MECHANICS,
	HandbookEntry.Group.MOVEMENT,
]

@onready var target: Control = $"%Target"

var _tree_root: TreeItem
var _systems: Systems:
	get():
		if _systems == null:
			_systems = $"/root/MainGame/%Systems"
		return _systems

var _entries: Dictionary[HandbookEntry.Group, Array]:
	get():
		if _entries.size() == 0:
			var _dynamic: Dictionary[HandbookEntry.Group, Array] = _load_dynamic_entries()
			_entries = _load_entries(base_path)
			_entries.merge(_dynamic)
		return _entries

var _selection_lookup: Dictionary[String, TreeItem] = {}
var _validate_handbook_required: bool = false
	
func _ready() -> void:
	assert(target != null, "Missing target node!")
	assert(handbook_ui != null, "Missing handbook ui!")
	visibility_changed.connect(_visibility_has_changed)
	item_selected.connect(_entry_selected)

	_tree_root = create_item()
	_tree_root.set_selectable(0, false)
	_tree_root.set_text(0, handbook_translation.get_text())
	var keys: Array[HandbookEntry.Group] = _entries.keys()
	keys.sort()
	for key: HandbookEntry.Group in keys:
		print_debug(key)
		var group: TreeItem = create_item(_tree_root)
		var text: String = HandbookEntry.Group.find_key(key)
		if translations.has(key):
			text = translations[key].get_text()
		if group_icons.has(key):
			group.set_icon(0, group_icons[key])
			group.set_icon_max_width(0, max_entry_icon_size)

		group.set_text(0, text)
		group.set_selectable(0, false)
		_add_items_to_group(group, _entries[key])
		
	_collapse_all()
	_rebuild_tree()

func _exit_tree() -> void:
	_selection_lookup.clear()
	for key: HandbookEntry.Group in _entries:
		for entry: Variant in _entries[key]:
			if entry is HandbookEntry:
				entry.cleanup()

func _add_items_to_group(root: TreeItem, items: Array) -> void:
	if root == null:
		return
	if items.any(func(item: Variant) -> bool: 
					if item is HandbookEntry:
						return item.group in ordered_groups
					return false
	):
			items.sort_custom(_sort_handbook_entries)
	for item: Variant in items:
		if item is HandbookEntry:
			var entry: TreeItem = create_item(root)
			if item.has_identifier():
				_selection_lookup.set(item.get_identifier().key, entry)
			entry.set_text(0, item.get_display_name())
			entry.set_accept_children(false)
			entry.set_metadata(0, item)
			entry.set_tooltip_text(0, item.get_description())
			if not item.is_unlocked():
				entry.visible = false
			if not item.get_icon() == null:
				entry.set_icon_max_width(0, max_entry_icon_size)
				entry.set_icon(0, item.get_icon())

func _sort_handbook_entries(a: Variant, b: Variant) -> bool:
	var a_entry: HandbookEntry = a as HandbookEntry
	var b_entry: HandbookEntry = b as HandbookEntry
	if a_entry == null or b_entry == null:
		return false
	
	if a_entry.order_number == b_entry.order_number:
		return a_entry.get_display_name() < b_entry.get_display_name()
	return a_entry.order_number < b_entry.order_number


func _entry_selected() -> void:
	var entry: TreeItem = get_selected()
	var data: Variant = entry.get_metadata(0)
	if data is HandbookEntry:
		for child: Node in target.get_children():
			target.remove_child(child)
			
		var control: HandbookTemplate = data.get_entry_data()
		if not control == null:
			target.add_child(control)
			if not control.open_handbook_entry.is_connected(select_specific_entry_by_key):
				control.open_handbook_entry.connect(select_specific_entry_by_key)

func _load_dynamic_entries() -> Dictionary[HandbookEntry.Group, Array]:
	var return_entries: Dictionary[HandbookEntry.Group, Array] = {}
	for dynamic_entry: DynamicHandbookEntry in dynamic_entry_provider:
		return_entries.merge(dynamic_entry.get_dynamic_entries())

	for group_key: HandbookEntry.Group in return_entries.keys():
		for entry: HandbookEntry in return_entries.get(group_key):
			entry.set_unlock_bridge(handbook_ui.get_unlock_bridge())
	return return_entries

func _load_entries(root: String, level: int = 0) -> Dictionary[HandbookEntry.Group, Array]:
	if level > scan_depth:
		return {}
	var return_data: Dictionary[HandbookEntry.Group, Array] = {}
	for file: String in DirAccess.get_files_at(root):
		if file.ends_with(".remap"):
			file = file.trim_suffix(".remap")
		if not file.ends_with("tres"):
			continue
		var path: String = "%s/%s" % [root, file]
		
		var data: Resource = load(path)
		if data is HandbookEntry:
			data.set_unlock_bridge(handbook_ui.get_unlock_bridge())
			if return_data.has(data.get_group()):
				return_data[data.get_group()].append(data)
				continue
			return_data.set(data.get_group(), [data])
	
	for directory: String in DirAccess.get_directories_at(root):
		var loaded_data: Dictionary[HandbookEntry.Group, Array] = _load_entries("%s/%s" % [root,  directory], level + 1)
		return_data.merge(loaded_data)

	return return_data

func select_specific_entry(entry: HandbookEntryIdentifier) -> void:
	select_specific_entry_by_key(entry.key)

func select_specific_entry_by_key(key: String) -> void:
	if _selection_lookup.has(key):
		_collapse_all()
		var selection: TreeItem = _selection_lookup[key]
		_expand_upward(selection)
		selection.select(0)

func _collapse_all(root: TreeItem = _tree_root) -> void:
	for group: TreeItem in root.get_children():
		group.set_collapsed_recursive(true)

func _expand_upward(leaf: TreeItem) -> void:
	if leaf == null:
		return
	if leaf.get_parent() == null:
		leaf.set_collapsed_recursive(false)
		return
	if leaf.get_parent() == _tree_root:		
		leaf.set_collapsed_recursive(false)
		return
	_expand_upward(leaf.get_parent())

func data_has_changed() -> void:
	_validate_handbook_required = true

func _visibility_has_changed() -> void:
	if not visible or not _validate_handbook_required:
		return
	_validate_handbook_required = false
	_rebuild_tree()

func _rebuild_tree() -> void:
	_revalidate_all_entries(_tree_root)
	_hide_empty_groups(_tree_root)

func _revalidate_all_entries(root: TreeItem) -> void:
	for item: TreeItem in root.get_children():
		var entry: Variant = item.get_metadata(0)
		if entry is HandbookEntry:
			if entry == null:
				continue
			item.visible = entry.is_unlocked()
		_revalidate_all_entries(item)

func _hide_empty_groups(root: TreeItem) -> void:
	if root.get_child_count() == 0:
		return

	root.visible = false
	if root.get_children().any(func(child: TreeItem) -> bool: return child.visible):
		root.visible = true
	for child: TreeItem in root.get_children():
		_hide_empty_groups(child)
