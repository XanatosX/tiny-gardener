class_name AudioSettings extends Resource

const MIN_AUDIO_VOLUME: float = -80
const MAX_AUDIO_VOLUME: float = 6.0

@export_range(MIN_AUDIO_VOLUME, MAX_AUDIO_VOLUME) var master_volume: float = 0	
@export_range(MIN_AUDIO_VOLUME, MAX_AUDIO_VOLUME) var effect_volume: float = 0
@export_range(MIN_AUDIO_VOLUME, MAX_AUDIO_VOLUME) var music_volume: float = 0
