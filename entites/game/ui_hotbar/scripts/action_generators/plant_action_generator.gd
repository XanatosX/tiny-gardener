class_name PlantActionGenerator extends SubActionGenerator

func generate_sub_entries(sub_actions: Array[UIActionTemplate], game_state_system: GameDataSystem, actionTemplate: UiDynamicActionTemplate) -> void:
	for action_template: UIActionTemplate in sub_actions:
		action_template.visible = false
		action_template.is_available = false

	var created: int = 0
	for current_seed: PlantData in game_state_system.get_available_seeds():
		var instance: UIActionTemplate = actionTemplate.get_action_template()
		if instance == null:
			return
		instance.action_icon = current_seed.icon
		instance.action_name = actionTemplate.action_name
		instance.item = current_seed
		instance.is_available = true
		instance.init()
		created += 1
		if created >= actionTemplate.max_entries:
			break