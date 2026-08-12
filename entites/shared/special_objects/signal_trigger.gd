class_name SignalTrigger extends Node3D

signal triggered()

func trigger() -> void:
	triggered.emit()