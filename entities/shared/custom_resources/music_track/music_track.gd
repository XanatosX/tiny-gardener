class_name MusicTrack extends Resource

@export var name: String
@export var allowed_locations: Array[MusicPlayerService.AudioLocation] = [   
	MusicPlayerService.AudioLocation.MENU,
	MusicPlayerService.AudioLocation.GAME
]

@export var artist: MusicArtist
@export var track: AudioStream

## A modifier of 1.0 means no changes, going closer to 0 will turn down the volume
@export_range(0.0, 1.0) var volume_modifier: float = 1.0

func get_length_in_seconds() -> float:
	return track.get_length()
