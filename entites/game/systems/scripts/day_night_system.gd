class_name DayNightCycleSystem extends TickDependentSystem

enum DayTime
{
	NONE,
	SUNRISE,
	MIDDAY,
	SUNSET,
	MIDNIGHT,
}

signal sunset()
signal midday()
signal sunrise()
signal midnight()
signal day_time_changed(day_time: DayTime)
signal day_percentage(percentage: float)

@export var time_start: DayTime = DayTime.SUNRISE
@export var day_length_ticks: int = 60

var _current_time_phase: DayTime = DayTime.NONE

var _current_day_tick: int = 0
var _sunrise_tick: int = 0
var _midday_tick: int = 0
var _sunset_tick: int = 0
var _midnight_tick: int = 0

func _ready() -> void:
	super()
	var game_ready_system: GameReadySystem = _systems.get_system("GameReadySystem")
	if not game_ready_system.game_is_ready():
		await game_ready_system.game_ready
	var parts: int = day_length_ticks / 4
	_sunrise_tick = parts
	_midday_tick = parts * 2
	_sunset_tick = parts * 3
	_midnight_tick = parts * 4

	match time_start:
		DayTime.SUNRISE: 
			_current_day_tick = _sunrise_tick
		DayTime.MIDDAY:
			_current_day_tick = _midday_tick
		DayTime.SUNSET:
			_current_day_tick = _sunset_tick
		DayTime.MIDNIGHT:
			_current_day_tick = _midnight_tick

	_on_tick()
	_current_day_tick -= 1
		
func _on_tick() -> void:
	var percentage: float = float(_current_day_tick) / float(day_length_ticks)
	day_percentage.emit(percentage)
	_define_current_state()
	
	_current_day_tick += 1
	if _current_day_tick >= day_length_ticks:
		_current_day_tick = 0

func _define_current_state() -> void:
	if _current_day_tick < _sunrise_tick:
		_change_day_time(DayTime.MIDNIGHT)
	if _current_day_tick > _sunrise_tick and _current_day_tick <= _midday_tick:
		_change_day_time(DayTime.MIDDAY)
	if _current_day_tick > _midday_tick and _current_day_tick <= _sunset_tick:
		_change_day_time(DayTime.SUNSET)
	if _current_day_tick > _sunset_tick and _current_day_tick <= _midnight_tick:
		_change_day_time(DayTime.MIDNIGHT)
	if _current_day_tick >= _sunrise_tick:
		_change_day_time(DayTime.SUNRISE)

func _change_day_time(day_time: DayTime) -> void:
	if day_time == _current_time_phase:
		return
	_current_time_phase = day_time
	match day_time:
		DayTime.SUNRISE: 
			sunrise.emit()
			day_time_changed.emit(DayTime.SUNRISE)
		DayTime.MIDDAY:
			midday.emit()
			day_time_changed.emit(DayTime.MIDDAY)
		DayTime.SUNSET:
			sunset.emit()
			day_time_changed.emit(DayTime.SUNSET)
		DayTime.MIDNIGHT:
			midnight.emit()
			day_time_changed.emit(DayTime.MIDNIGHT)

func game_saving(save_game: SaveGame) -> void:
	save_game.day_time_tick = _current_day_tick

func game_loaded(save_game: SaveGame) -> void:
	if save_game.last_save_date_unix_time == 0:
		return
	_current_day_tick = save_game.day_time_tick
