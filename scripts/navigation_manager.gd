extends Node

const scene_lobby = preload("res://map.tscn")
const scene_level1 = preload("res://map_2.tscn")
const scene_level2 = preload("res://Map3.tscn")
const scene_level2pt2 = preload("res://map_2_pt_2.tscn")

signal on_trigger_player_spawn

var spawn_door_tag 

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"map":
			scene_to_load = scene_lobby
		"map_2":
			scene_to_load = scene_level1
		"Map3":
			scene_to_load = scene_level2
		"map_2_pt_2":
			scene_to_load = scene_level2pt2
			
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		get_tree().change_scene_to_packed(scene_to_load)

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
