@abstract
class_name UiDisplayRule extends Resource

## Remove the ui element instead of hiding it
@export var remove: bool = false

func should_remove() -> bool:
	return remove

@abstract
func should_be_visible() -> bool