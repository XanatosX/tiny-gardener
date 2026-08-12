class_name Voice extends Resource

@export var voice_frequency: int = 5
@export var voice_audio: AudioStream
@export_range(0.5, 1, 0.05) var min_pitch: float = 0.8
@export_range(1, 2, 0.05) var max_pitch: float = 1.2
@export_range(-20, 0, 0.05) var min_db: float = -3
@export_range(0, 3, 0.05) var max_db: float = 3
