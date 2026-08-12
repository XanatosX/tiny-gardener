extends Node

var _global_audio_players: Array[AudioStreamPlayer] = []

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