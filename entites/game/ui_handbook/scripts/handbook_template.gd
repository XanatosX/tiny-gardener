class_name HandbookTemplate extends MarginContainer

signal open_handbook_entry(key: String)
signal data_changed(data: HandbookEntry)
signal update_headline(headline: String)
signal no_icon()
signal set_icon(icon: Texture)

var current_data: HandbookEntry

func _ready() -> void:
	_update_data()

func set_data(data: HandbookEntry) -> void:
	current_data = data
	_update_data()
	if is_node_ready():
		data_changed.emit(data)

func _update_data() -> void:
	if not is_node_ready() or current_data == null:
		return
	data_changed.emit(current_data)
	update_headline.emit(current_data.get_display_name())
	if current_data.get_icon() == null:
		no_icon.emit()
		return
	set_icon.emit(current_data.get_icon())

func request_handbook_entry(key: String) -> void:
	open_handbook_entry.emit(key)