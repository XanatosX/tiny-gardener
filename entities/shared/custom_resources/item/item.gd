@abstract class_name Item extends Resource

enum QUALITY
{
	NONE,
	POOR,
	STANDARD,
	PREMIUM
}


@export_group("Common")
@export var display_name: TextTranslation
@export var description: TextTranslation
## This description os optional and will be used for the handbook entry if set.
## Otherwise the normal description is used
@export var long_description: TextTranslation
@export var icon: Texture = null
@export var quality: QUALITY = QUALITY.NONE

@export_group("Commercial")
@export var can_buy: bool = true
@export var can_sell: bool = true
@export var price: float = 0.0
## The amount to multiply with to get the sell price
@export var sell_modifier: float = 1.0

@export_group("Display Settings")
@export var show_quality_in_name: bool = true

@export_group("Quality items")
@export var _poor_quality_icon: Texture = preload("res://assets/atlas/poor_quality_icon.tres")
@export var _standard_quality_icon: Texture = preload("res://assets/atlas/standard_quality_icon.tres")
@export var _premium_quality_icon: Texture = preload("res://assets/atlas/premium_quality_icon.tres")

@export var _poor_quality_name: TextTranslation = preload("res://assets/resources/translations/poor_quality_name.tres")
@export var _standard_quality_name: TextTranslation = preload("res://assets/resources/translations/standard_quality_name.tres")
@export var _premium_quality_name: TextTranslation = preload("res://assets/resources/translations/premium_quality_name.tres")

func get_sell_price() -> float:
	return price * sell_modifier * _get_quality_modifier()

func get_price() -> float:
	return price

func get_display_name() -> String:
	if quality == QUALITY.NONE:
		return display_name.get_text()
	if not show_quality_in_name:
		return display_name.get_text()
	return "%s (%s)" % [display_name.get_text(), get_quality_name()]

func get_long_description() -> String:
	if long_description != null:
		return long_description.get_text()
	if description != null:
		return description.get_text()
	
	return ""

func is_identically(item: Item) -> bool:
	return display_name.key == item.display_name.key \
			and quality == item.quality \
			and price == item.price \
			and sell_modifier == item.sell_modifier

func _get_quality_modifier() -> float:
	match quality:
		Item.QUALITY.POOR:
			return 0.75
		Item.QUALITY.STANDARD:
			return 1.0
		Item.QUALITY.PREMIUM:
			return 1.5
	return 1.0

func get_quality_icon() -> Texture:
	match quality:
		Item.QUALITY.POOR:
			return _poor_quality_icon
		Item.QUALITY.STANDARD:
			return _standard_quality_icon
		Item.QUALITY.PREMIUM:
			return _premium_quality_icon
	return null

func get_quality_name() -> String:
	match quality:
		Item.QUALITY.POOR:
			return _poor_quality_name.get_text()
		Item.QUALITY.STANDARD:
			return _standard_quality_name.get_text()
		Item.QUALITY.PREMIUM:
			return _premium_quality_name.get_text()
	return ""

func bought() -> void:
	pass