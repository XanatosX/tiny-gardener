class_name CharacterInformation extends Resource

enum Mood
{
	DEFAULT,
	SAD,
	ANGRY,
	SCARED,
	EXITED,
	THINKING
}

@export var display_icons: Dictionary[Mood, Texture]
@export var voices: Dictionary[Mood, Voice]
@export var display_name: TextTranslation
@export var backstory: TextTranslation

func get_voice_for_mood(mood: Mood) -> Voice:
	assert(voices.has(Mood.DEFAULT), "Character is missing fallback speaking sound")
	if not voices.has(mood):
		return voices.get(Mood.DEFAULT)
	return voices.get(mood)

func get_icon_for_mood(mood: Mood) -> Texture2D:
	assert(display_icons.has(Mood.DEFAULT), "Character is missing fallback icon")
	if not display_icons.has(mood):
		return display_icons.get(Mood.DEFAULT)
	return display_icons.get(mood)
