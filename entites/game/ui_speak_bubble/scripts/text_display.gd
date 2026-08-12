class_name TextDisplay extends RichTextLabel

signal animation_done()
signal display_new_text()
signal no_more_text()

@export_group("Letters")
@export var time_per_char: float = 0.3
@export var max_text_length: int = 200

@export_group("Voice")
@export var fallback_voice: Voice

var _text_queue: Array[String] = []
var _char_speaking_voice: Voice = null
var _letter_count: int = 0

func _init() -> void:
	bbcode_enabled = true

func _ready() -> void:
	assert(fallback_voice != null, "Missing fallback audio stream")

func set_spoken_message(message: SpokenMessage) -> void:
	set_animation_text(message.message.get_text())
	_char_speaking_voice = message.character.get_voice_for_mood(message.message_mood)

func set_animation_text(new_text: String) -> void:
	if _smart_split_text(new_text):
		show_next_text()
		return
	_set_new_text(new_text)
	_animate_current_text()

func _get_spoken_audio() -> Voice:
	if _char_speaking_voice != null:
		return _char_speaking_voice
	return fallback_voice

func _smart_split_text(new_text: String) -> bool:
	if new_text.length() > max_text_length:
		while new_text.length() > max_text_length:
			for i: int in max_text_length:
				var index: int = max_text_length - i
				if new_text[index] == " ":
					_text_queue.append(new_text.substr(0, index))
					new_text = new_text.substr(index + 1, -1)
					break
		if new_text.length() < max_text_length:
			_text_queue.append(new_text)
		return true
	return false

func show_next_text() -> void:
	_letter_count = 0
	if _text_queue.size() == 0:
		_char_speaking_voice = null
		animation_done.emit()
		no_more_text.emit()
		return
	var new_text: String = _text_queue.pop_front()
	_set_new_text(new_text)
	_animate_current_text()

func _set_new_text(new_text: String) -> void:
	text = new_text	
	visible_characters = 0

func _animate_current_text() -> void:
	display_new_text.emit()
	var total_time: float = text.length() * time_per_char
	var tween: Tween = create_tween()
	tween.tween_method(_show_character, 0, text.length(), total_time)
	tween.finished.connect(_text_animation_done)

func _show_character(visible_chars: int) -> void:
	visible_characters = visible_chars

	
	_letter_count -= 1
	if _letter_count <= 0:
		var voice: Voice = _get_spoken_audio()
		AudioService.play_global_audio_effect(voice.voice_audio, randf_range(voice.min_pitch, voice.max_pitch), randf_range(voice.min_db, voice.max_db))
		_letter_count = voice.voice_frequency

func _text_animation_done() -> void:
	animation_done.emit()

func clear_message() -> void:
	text = ""
	visible_characters = 0