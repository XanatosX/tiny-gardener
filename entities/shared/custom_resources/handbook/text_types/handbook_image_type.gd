class_name HandbookImageType extends HandbookTextType

@export var centered: bool = true
@export var image: Texture2D
@export var image_size: Vector2i = Vector2(64,64)

func get_text() -> String:
	var return_data: String = "[img=%d,%d]%s[/img]" % [image_size.x,image_size.y, image.resource_path]
	if centered:
		return_data = "[center]%s[/center]" % return_data

	return return_data
