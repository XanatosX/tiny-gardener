class_name AreaStateWatcher extends StateWatcher

func body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		state.open = true

func body_left(body: Node3D) -> void:
	if body is CharacterBody3D:
		state.open = false