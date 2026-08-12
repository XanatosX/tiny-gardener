extends Node

const ITEMS_PATH: String = "res://assets/resources/items/"

var _game_items: Array[Item]:
	get():
		if _game_items.size() == 0:
			_game_items = _load_items(ITEMS_PATH)
		return _game_items

func _ready() -> void:
	assert(DirAccess.dir_exists_absolute(ITEMS_PATH), "Missing item path")

func _reload_items() -> void:
	_game_items = []

func _load_items(root_path: String) -> Array[Item]:
	var return_data: Array[Item] = []
	for file: String in DirAccess.get_files_at(root_path):
		var path: String = "%s%s" % [root_path, file]
		if path.ends_with(".remap"):
			path = path.trim_suffix(".remap")
		var item: Item = load(path) as Item
		if item == null:
			continue
		return_data.append(item)
	
	for directory: String in DirAccess.get_directories_at(root_path):
		return_data.append_array(_load_items("%s%s/" % [root_path, directory]))
	
	return return_data

func get_all_items() -> Array[Item]:
	return _game_items