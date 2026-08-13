class_name PreprocessedRichTextLabel extends RichTextLabel

@export var preprocessors: Array[DynamicRichTextPreprocess]

func _process_text(new_text: String) -> String:
	for processor: DynamicRichTextPreprocess in preprocessors:
		new_text = processor.apply(new_text)
	return new_text

func set_preprocessed_text(new_text: String) -> void:
	text = _process_text(new_text)

func append_preprocessed_text(new_text: String) -> void:
	append_text(_process_text(new_text))
