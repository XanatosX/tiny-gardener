class_name ShopTabGroup extends TabContainer

@export var tab_translations: Array[TextTranslation]

func _ready() -> void:
	for index: int in get_tab_count():
		var tab_title: String = get_tab_title(index)
		var translation: String = _find_translation_for_string(tab_title)
		if not translation == "":
			set_tab_title(index, translation)

func _find_translation_for_string(data: String) -> String:
	var return_data: String = ""
	for translation: TextTranslation in tab_translations:
		if translation.key == data:
			return_data = translation.get_text()
			break
	return return_data
