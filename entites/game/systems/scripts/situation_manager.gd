class_name SituationManager extends System

const SITUATION_ROOT: String = "res://assets/resources/situations/"

signal _game_load_ready()

var _main_game: Node3D:
	get():
		if _main_game == null:
			_main_game = $"/root/MainGame"
		return _main_game

var _game_sequences: Sequences:
	get():
		if _game_sequences == null:
			_game_sequences = Sequences.new()
		return _game_sequences

var _available_situations: Array[Situation] = []:
	get():
		if _available_situations.size() == 0:
			_available_situations = _load_situations()
		return _available_situations

var _loaded: bool = false

func _load_situations() -> Array[Situation]:
	var situations: Array[Situation] = []
	for file: String in DirAccess.get_files_at(SITUATION_ROOT):
		var path: String = "%s/%s" % [SITUATION_ROOT, file]
		var data: Situation = load(path) as Situation
		assert(data != null, "Wrong data in situation folder")
		situations.append(data)
			
	return situations

func get_all_situations() -> Array[Situation]:
	return _available_situations

func get_all_seen_situations() -> Array[Situation]:
	return _game_sequences.get_all_seen_situations()

func situation_seen(situation: Situation) -> bool:
	return _game_sequences.situation_seen(situation)

func play_situation(situation: Situation, situation_objects: Array[SituationObject] = []) -> void:
	assert(situation.situation_steps.size() > 0, "Situation without any steps provided")
	if not _loaded:
		await _game_load_ready
	if _game_sequences.situation_seen(situation):
		return
	for requirement: Situation in situation.requirements:
		if not _game_sequences.situation_seen(requirement):
			return
			
	_game_sequences.add_known_situations(situation)
	for step: SituationStep in situation.situation_steps:
		await step.execute(_situation_finished, _systems, _main_game, situation_objects)
	

func _situation_finished() -> void:
	pass

func game_save(save: SaveGame) -> void:
	save.sequences = _game_sequences

func game_loaded(save: SaveGame) -> void:
	_game_sequences = save.sequences
	_loaded = true
	_game_load_ready.emit()
