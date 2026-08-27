extends Node

const MASTER_BUS: String = "Master"
const EFFECT_BUS: String = "sfx"
const MUSIC_BUS: String = "music"

var _global_audio_players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	if not SettingsService.is_node_ready():
		await SettingsService.ready
	SettingsService.settings_changed.connect(_settings_changed)
	_settings_changed(SettingsService.get_settings())

func _settings_changed(game_settings: GameSettings) -> void:
	set_audio_channels(game_settings.audio_settings)

func set_audio_channels(audio_settings: AudioSettings) -> void:
	_set_bus_volume(MASTER_BUS, audio_settings.master_volume)
	_set_bus_volume(EFFECT_BUS, audio_settings.effect_volume)
	_set_bus_volume(MUSIC_BUS, audio_settings.music_volume)

func _set_bus_volume(bus_name: String, volume_db: float) -> void:
	var id: int = AudioServer.get_bus_index(bus_name)
	if id == -1:
		return
	AudioServer.set_bus_volume_db(id, volume_db)

func play_global_audio_effect(effect: AudioStream, pitch: float = 0, volume: float = 0) -> void:
	if effect == null:
		return
	pitch = clampf(pitch, 0.5, 2)
	volume = clampf(volume, -80, 24)
	var player: AudioStreamPlayer = _get_audio_player()
	player.volume_db = volume
	player.pitch_scale = pitch
	player.stream = effect
	player.play()

func _get_audio_player() -> AudioStreamPlayer:
	var return_player: AudioStreamPlayer = _get_usable_player()
	if return_player == null:
		return_player = _create_new_player()
	return return_player

func _create_new_player() -> AudioStreamPlayer:
	var return_player: AudioStreamPlayer = AudioStreamPlayer.new()
	return_player.bus = "sfx"
	_global_audio_players.append(return_player)
	add_child(return_player)
	return return_player

func _get_usable_player()  -> AudioStreamPlayer:
	for player: AudioStreamPlayer in _global_audio_players:
		if not player.playing:
			return player
	return null