extends Node

func _ready():
	if NavigationManager.spawn_door_tag != null:
		_on_level_spawn(NavigationManager.spawn_door_tag)
	# emit_signal("spawn_at_position", Vector2(100, 100)) # Example position

func _on_level_spawn(destination_tag: String):
	var door_path = "Doors/Door_" + destination_tag  # corrected the path separator
	print("Door Path: ", door_path)
	var door = get_node(door_path) as Door
	if door:
		print("Door found: ", door)
		NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
	else:
		print("Error: Door not found!")

signal spawn_at_position(Vector2)

# Assuming this script is attached to a node in the map scene


#func _some_function_that_triggers_spawn():
#	var map_scene = get_node("/root/MapScene") # Assuming MapScene is a root node in the scene tree
#	map_scene.spawn_at_position(Vector2(300, 100)) # Trigger the spawn function in the MapScene
