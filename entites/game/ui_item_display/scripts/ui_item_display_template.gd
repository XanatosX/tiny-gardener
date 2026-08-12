class_name UiItemDisplayTemplate extends MarginContainer

signal timeout()
signal update_name(display_name: String)
signal update_description(display_name: String)
signal update_quality(texture: Texture)
signal update_texture(texture: Texture)
signal update_amount(string: int)

@export var display_time: float = 3
@export var animation_time: float = 0.4

var _start_position: Vector2 = Vector2.ZERO

var _item: Item = null
var _amount: int = 0

func _init() -> void:
	offset_transform_enabled = true
	visible = false

func set_data(item: Item, amount: int, start_position: Vector2 = Vector2.ZERO) -> void:
	_start_position = start_position
	_item = item
	_amount = amount
	

func enable() -> void:
	if _item == null:
		return
	update_name.emit(_item.get_display_name())
	update_description.emit(_item.description.get_text())
	update_texture.emit(_item.icon)
	update_amount.emit(str(_amount))
	update_quality.emit(_item.get_quality_icon())

	offset_transform_position = _start_position
	visible = true
	var tween: Tween = create_tween()
	tween.tween_property(self, "offset_transform_position", Vector2.ZERO, animation_time)
	await tween.finished

	get_tree().create_timer(display_time).timeout.connect(_fade_out)	

func disable() -> void:
	visible = false

func _fade_out() -> void:
	var tween: Tween = create_tween()

	tween.tween_property(self, "offset_transform_position", _start_position, animation_time)
	await tween.finished
	timeout.emit()