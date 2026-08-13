class_name MoveWaypointsStep extends SituationStep

@export var waypoint_set_name: String

func execute(_on_finished: Callable,
			_systems: Systems,
			_main_game: Node3D,
			situation_objects: Array[SituationObject]) -> void:
	var waypoints: Array[Waypoint] = []
	for object: SituationObject in situation_objects:
		if object is Waypoint:
			if object.name_of_waypoint_set == waypoint_set_name:
				waypoints.append(object)
	if waypoints.size() == 0:
		return
	var player: PlayerController = _main_game.find_child("Player", true)
	if player == null or not player.can_move_automatically():
		return
	for waypoint: Waypoint in waypoints:
		player.move_to_node(waypoint)
		await player.target_reached
		