class_name ImageTableText extends HandbookTextType

@export var columns: int  = 0
@export var center: bool = false
@export var image_size: int = 64
@export var rows: Array[RowData]

func get_text() -> String:
	return _build_table()

func _build_table() -> String:
	var return_data: String = "[table=%d%s]" % [columns, ",center" if center else "" ]
	if center:
		return_data = "%s%s%s" % ["[center]", return_data, "[/center]"]
	for row: RowData in rows:
		for texture: Texture2D in row.images:
			var data: String = "[cell][/cell]"
			if texture != null:
				data = "[cell][img=%d,%d]%s[/img][/cell]" % [image_size, image_size, texture.resource_path]
			return_data += data
	return_data = "%s[/table]" % return_data
	return return_data


