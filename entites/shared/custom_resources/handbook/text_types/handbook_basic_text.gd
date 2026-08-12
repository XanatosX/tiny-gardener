class_name HandbookBasicText extends HandbookTextType

@export var translation: TextTranslation
@export var centered: bool = false

func get_text() -> String:
	var return_data: String = translation.get_text()
	if centered:
		return_data = "[center]%s[/center]" % return_data
	return return_data