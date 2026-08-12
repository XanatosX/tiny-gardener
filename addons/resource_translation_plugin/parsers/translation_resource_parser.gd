@tool
class_name TranslationResourceParser extends TranslationPlugin

func parse(path: String) -> Array[PackedStringArray]:
	var resource: Resource = load(path)
	if not resource is TextTranslation:
		return []
	var translation: TextTranslation = resource as TextTranslation
	return [PackedStringArray([resource.key, resource.context, resource.plural, resource.comment])]

func get_extension() -> PackedStringArray:
	return["tres"]

func register_or_change_translations(strings: Array[PackedStringArray]):
	print(strings)
	for file: String in _get_all_resources():
		if file.get_extension() in get_extension():
			print("Add for translation: \"%s\"" % file)
			var generated_data: Array[PackedStringArray] = parse(file)
			for data_set: PackedStringArray in generated_data:
				var diff: int = 4 - data_set.size()
				if diff > 1:
					for i in diff:
						data_set.append("")
				if data_set.size() < 5:
					data_set.append(file)
			strings.append_array(generated_data)
	
	return strings