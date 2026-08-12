class_name TextTranslation extends Resource

## The key to translate
@export var key: String
## The context of this translation
@export var context: String = ""
## The translation if plural is needed
@export var plural: String = ""
## Any comments for the person translating the string
@export var comment: String = ""

func get_text() -> String:
	return tr(key)