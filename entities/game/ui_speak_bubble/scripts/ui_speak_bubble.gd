@tool
class_name UiSpeakBubble extends FrostedGlassControlPanel

signal clear_message()
signal update_icon(texture: Texture2D)
signal update_character_name(name: String)
signal set_character_backstory(backstory: String)
signal update_message(message: SpokenMessage)
signal dialog_started()
signal dialog_done()

@export var animation_time: float = 0.3

var _message_queue: Array[SpokenMessage] = []
var _initial_offset: Vector2 = Vector2.ZERO
var _dialog_mode: bool = false

func _ready() -> void:
	_initial_offset = offset_transform_position

func _animate_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "offset_transform_position", Vector2.ZERO, animation_time)
	await tween.finished

func _animate_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "offset_transform_position", _initial_offset, animation_time)
	await tween.finished

func set_dialog(dialog: Dialog) -> void:
	if _message_queue.size() > 0:
		return
	_dialog_mode = true
	dialog_started.emit()
	_message_queue.append_array(dialog.spoken_messages)
	display_next_message()

func display_next_message() -> void:
	if _message_queue.size() == 0:
		if not _dialog_mode:
			return
		_dialog_mode = false
		await _animate_out()
		dialog_done.emit()
		process_mode = Node.PROCESS_MODE_DISABLED
		visible = false
		return
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
	set_spoken_message(_message_queue.pop_front())

func set_spoken_message(message: SpokenMessage) -> void:
	update_character_name.emit(message.character.display_name.get_text())
	set_character_backstory.emit(message.character.backstory.get_text())
	update_icon.emit(message.character.get_icon_for_mood(message.message_mood))
	clear_message.emit()
	if offset_transform_position != Vector2.ZERO:
		await _animate_in()
	update_message.emit(message)
