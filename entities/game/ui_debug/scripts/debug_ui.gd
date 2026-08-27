@tool
class_name DebugUi extends FrostedGlassControlPanel

@export var visible_at_start: bool = false
@export var register_console_command: bool = true
@export var display_rule: UiDisplayRule = null

func _ready() -> void:
	visible = visible_at_start
	if display_rule != null and not display_rule.should_be_visible():
		visible = false
		if display_rule.should_remove():
			queue_free()
			return
	
	_register_game_commands()

func _register_game_commands() -> void:
	if not register_console_command:
		return
	tree_exiting.connect(_tree_left)
	Console.register_command(Command.create("show_debug")
								    .calling_method(_toggle_visibility)
									.with_argument(CommandArgument.create("state")
									                              .of_type(CommandArgument.Type.BOOL)
																  .with_description("Show or hide debug menu")
																  .finalize()
									)
									.documentation()
									.with_description("Show or hide the debug menu of the game")
									.finalize()
									)

func _tree_left() -> void:
	Console.remove_command("show_debug")

func _toggle_visibility(new_state: bool) -> String:
	visible = new_state
	return ""