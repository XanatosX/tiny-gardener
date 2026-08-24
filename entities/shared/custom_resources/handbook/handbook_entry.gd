@abstract
class_name HandbookEntry extends Resource

enum Group
{
	MOVEMENT,
	GAME_MECHANICS,
	ITEMS,
	FERTILIZER,
	DROPS,
	PLANTS,
	UPGRADES,
}

@export var identifier: HandbookEntryIdentifier
@export var icon: Texture2D
@export var group: Group
@export var display_name: TextTranslation
@export var description: TextTranslation
@export var scene_template: PackedScene
@export var order_number: int = 0

var _unlock_bridge: UnlockBridge = null

var _template: HandbookTemplate = null:
	get():
		if _template == null:
			_template = scene_template.instantiate()
		return _template

var _display_name_overwrite: String
var _description_overwrite: String

func has_identifier() -> bool:
	return not get_identifier() == null

func get_identifier() -> HandbookEntryIdentifier:
	return identifier

func get_icon() -> Texture2D:
	return icon

func get_group() -> Group:
	return group

func set_display_name_overwrite(overwrite: String) -> void:
	_display_name_overwrite = overwrite

func set_description_overwrite(overwrite: String) -> void:
	_description_overwrite = overwrite

func get_display_name() -> String:
	if _display_name_overwrite != "":
		return _display_name_overwrite
	if display_name == null:
		return "MISSING TEXT"
	return display_name.get_text()

func get_description() -> String:
	if _description_overwrite != "":
		return _description_overwrite
	if description == null:
		return ""
	return description.get_text()

func is_unlocked() -> bool:
	return scene_template != null

func _get_template_instance() -> HandbookTemplate:
	return _template

@abstract
func get_entry_data() -> HandbookTemplate

func set_unlock_bridge(bridge: UnlockBridge) -> void:
	if _unlock_bridge != null:
		return
	_unlock_bridge = bridge

func cleanup() -> void:
	if _template != null:
		_template.queue_free()
