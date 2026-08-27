class_name DebugVisibleDisplayRule extends UiDisplayRule

@export_flags("debug:1", "release:2") var visible_at: int = 3

func should_be_visible() -> bool:
	var is_debug: bool = OS.has_feature("debug")
	var is_release: bool = OS.has_feature("release")
	if is_debug and visible_at & 1:
		return true
	if is_release and visible_at & 2:
		return true
	return false
	
