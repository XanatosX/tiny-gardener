class_name PlayerEnterAreaTrigger extends SituationTrigger

@export var area: Area3D

func _ready() -> void:
	assert(area != null, "Missing trigger area")
	area.body_entered.connect(_body_entered)

func _body_entered(node: Node3D) -> void:
	if node is PlayerController:
		trigger.emit()