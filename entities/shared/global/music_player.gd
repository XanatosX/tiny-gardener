class_name MusicPlayerService extends Node

const MUSIC_TRACK_DIRECTORY: String = "res://assets/resources/music/tracks/"
const FADE_TIME_SECONDS: float = 1
const DIALOG_FADE_TIME: float = 0.2
const MAX_DEPTH: int = 2
const REQUIRED_PLAYERS: int = 2
const LAST_FORBIDDEN_TRACKS: int = 1
const DIALOG_MULTIPLIER: float =  0.15

signal track_changed(new_track: MusicTrack)

enum AudioLocation
{
	MENU,
	GAME
}

var _tracks: Array[MusicTrack] = []
var _last_tracks: Array[MusicTrack] = []

var _players: Array[AudioStreamPlayer]

var _active_track: MusicTrack

var _active_player: AudioStreamPlayer = null
var _passive_player: AudioStreamPlayer = null
var _current_location: AudioLocation = AudioLocation.MENU
var _target_volume: float = 1.0
var _in_dialog: bool = false
var _transition: bool = false

var _active_timer: SceneTreeTimer = null

func _init() -> void:
	_scan_directory_for_tracks(MUSIC_TRACK_DIRECTORY)
	for i: int in REQUIRED_PLAYERS:
		var player: AudioStreamPlayer = _create_audio_stream_player()
		_players.append(player)

	_active_player = _players[0]
	_passive_player = _players[1]

func _ready() -> void:
	switch_location(AudioLocation.GAME)

func _scan_directory_for_tracks(root: String, depth: int = 0) -> void:
	if depth >= MAX_DEPTH:
		return
	if not root.ends_with("/"):
		root = root + "/"
	if not DirAccess.dir_exists_absolute(root):
		return
	for file: String in DirAccess.get_files_at(root):
		if file.ends_with(".remap"):
			file = file.trim_suffix(".remap")
		if not file.ends_with("tres"):
			continue
		var path: String = "%s%s" % [root, file]
		var loaded: Resource = load(path)
		if loaded is MusicTrack:
			_tracks.append(loaded)

	for directory: String in DirAccess.get_directories_at(root):
		var path: String = "%s%s" % [root, directory]
		_scan_directory_for_tracks(path, depth + 1)

func _create_audio_stream_player() -> AudioStreamPlayer:
	var return_player: AudioStreamPlayer = AudioStreamPlayer.new()
	return_player.bus = "music"
	add_child(return_player)
	return return_player

func switch_location(new_location: AudioLocation) -> void:
	_current_location = new_location
	if not _active_player.playing or not _current_location in _active_track.allowed_locations:
		_play_next_track()

func _play_next_track() -> void:
	if _active_track == null:
		_play_new_track()
		return
	var new_player: AudioStreamPlayer = _passive_player
	_passive_player = _active_player
	_active_player = new_player

	_active_track = _get_next_random_track()
	_active_player.volume_linear = 0
	_active_player.stream = _active_track.track
	track_changed.emit(_active_track)
	_create_next_track_timer(_active_track)
	_active_player.play()

	_transition = true
	var tween :Tween = create_tween()
	tween.finished.connect(func() -> void: _transition = false)
	tween.parallel()
	tween.tween_property(_passive_player, "volume_linear", 0.0, FADE_TIME_SECONDS)
	tween.tween_property(_active_player, "volume_linear", _get_track_volume(_active_track) * _get_volume_multiplier(), FADE_TIME_SECONDS)

func _get_track_volume(track: MusicTrack) -> float:
	return _target_volume * track.volume_modifier

func _play_new_track() -> void:
	_active_track = _get_next_random_track()

	_active_player.stream = _active_track.track
	_active_player.volume_linear = _get_track_volume(_active_track) * _get_volume_multiplier()
	print(_active_player.volume_linear)
	track_changed.emit(_active_track)
	_create_next_track_timer(_active_track)
	_active_player.play()

func _create_next_track_timer(track: MusicTrack) -> void:
	if _active_timer != null:
		if _active_timer.timeout.is_connected(_play_next_track):
			_active_timer.timeout.disconnect(_play_next_track)
	_active_timer = get_tree().create_timer(track.get_length_in_seconds() - FADE_TIME_SECONDS)
	_active_timer.timeout.connect(_play_next_track)

func _get_volume_multiplier() -> float:
	if _in_dialog:
		return DIALOG_MULTIPLIER
	return 1.0

func dialog_changed(in_dialog: bool) -> void:
	_in_dialog = in_dialog
	if _transition:
		return
	var new_volume: float = _get_track_volume(_active_track)
	if _in_dialog:
		new_volume = new_volume * _get_volume_multiplier()
	var tween: Tween = create_tween()
	tween.parallel()
	tween.tween_property(_active_player, "volume_linear", new_volume, DIALOG_FADE_TIME)

func _get_next_random_track() -> MusicTrack:
	var _return_track: MusicTrack = null
	var _allowed_tracks: Array[MusicTrack] = _get_possible_tracks()
	_return_track = _allowed_tracks.pick_random()
	_add_last_track(_return_track)
	return _return_track

func _add_last_track(track: MusicTrack) -> void:
	_last_tracks.append(track)
	var diff: int = _last_tracks.size() - LAST_FORBIDDEN_TRACKS
	if diff > 0:
		for i: int in diff:
			_last_tracks.pop_front()

func _get_possible_tracks() -> Array[MusicTrack]:
	var _allowed_tracks: Array[MusicTrack] = []
	for track: MusicTrack in _tracks:
		if _current_location in track.allowed_locations:
			if not track in _last_tracks:
				_allowed_tracks.append(track)
	return _allowed_tracks

func set_music_player_volume(new_volume: float) -> void:
	_target_volume = new_volume
	if _transition:
		return
	_active_player.volume_linear = _target_volume