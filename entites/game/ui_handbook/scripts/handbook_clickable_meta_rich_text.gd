class_name HandbookClickableMetaRichText extends RichTextLabel

signal open_handbook_entry(key: String)

func _ready() -> void:
	bbcode_enabled = true
	meta_clicked.connect(_handle_meta_clicked)

func _handle_meta_clicked(meta: Variant) -> void:
	var data: Dictionary = {}
	if meta is String:
		var parsed: Variant = JSON.parse_string(meta)
		if parsed is Dictionary:
			data = parsed
	if data.has("entry"):
		open_handbook_entry.emit(data["entry"])