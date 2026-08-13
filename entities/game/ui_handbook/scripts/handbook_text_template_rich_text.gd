class_name HandbookTextTemplateRichText extends HandbookClickableMetaRichText

func set_data(data: HandbookEntry) -> void:
	var final_text: String = ""
	text = ""
	if data is TextHandbookEntry:
		for part: HandbookTextType in data.handbook_parts:
			final_text += _process_text(part.get_text())
			final_text += "\n\n"

	text = final_text
