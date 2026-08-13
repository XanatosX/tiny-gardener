class_name DynamicImage extends DynamicRichTextPreprocess

const pattern: String = r"\[img(?:=[^\]]*)?\](.*?)\[/img\]"

## The order of the directories will define the search priority, if an asset was found in the first directory
## it will not continue searching on the second
@export var directories_to_check: Array[String] = [
	"res://assets/atlas/",
	"res://assets/textures/"
]

var _regex: RegEx = RegEx.new()

var _image_database: Dictionary[String, String] = {}

func _init() -> void:
	_regex.compile(pattern)

func apply(text: String) -> String:
	if directories_to_check.size() == 0:
		return text

	for match: RegExMatch in _regex.search_all(text):
		var path: String = match.get_string(1)
		if path != "" and not path.begins_with("res://"):
			var absolute_path: String = _get_real_path(path)
			if absolute_path == "":
				continue
			print(match.get_string(0))
			text = text.replace(match.get_string(1), absolute_path)
	return text

func _get_real_path(asset_name: String) -> String:
	if _image_database.has(asset_name):
		return _image_database.get(asset_name)

	for directory: String in directories_to_check:
		var resolved_path: String = _search_path(directory, asset_name)
		if resolved_path != "":
			_image_database.set(asset_name, resolved_path)
			return _get_real_path(asset_name)

	return asset_name
	
func _search_path(root: String, asset_name: String) -> String:
	if not DirAccess.dir_exists_absolute(root):
		return ""
	if not root.ends_with("/"):
		root = root + "/"
	for file: String in DirAccess.get_files_at(root):
		if file.ends_with(".import"):
			continue
		var name: String = file.replace(".%s" % file.get_extension(), "")
		if name == asset_name:

			var absolute: String = "%s%s" % [root, file]
			return absolute

	for directory: String in DirAccess.get_directories_at(root):
			var absolute: String = "%s/%s" % [root, directory]

			var file_match: String = _search_path(absolute, asset_name)
			if file_match != "":
				return file_match

	return ""
