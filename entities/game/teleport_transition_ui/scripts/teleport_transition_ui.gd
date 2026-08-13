class_name TeleportTransitionUi extends ColorRect

## The step where stuff can be done behind a hidden screen
const MIDDLE_STEP_START: int = 1

signal fully_black()
signal transition_done()

### The time to transit from transparent to black and from black to transparent
@export var transition_time: float = 0.6
@export var transition_black_time: float = 0.05

var _transition_in_progress: bool = false
var _initial_color: Color

func _ready() -> void:
	_initial_color = color
	color = _initial_color
	color.a = 0
	_transition_done()

func transit() -> void:
	if _transition_in_progress:
		return
	visible = true
	_transition_in_progress = true
	
	var tween: Tween = create_tween()
	tween.step_finished.connect(_step_done)
	tween.tween_property(self, "color", _initial_color, transition_time)
	tween.tween_property(self, "color", _initial_color, transition_black_time)
	tween.tween_property(self, "color", Color(_initial_color.r, _initial_color.g, _initial_color.b, 0), transition_time)
	tween.finished.connect(_transition_done)

func _transition_done() -> void:
	visible = false
	transition_done.emit()
	_transition_in_progress = false

func _step_done(count: int ) -> void:
	if count == MIDDLE_STEP_START:
		fully_black.emit()