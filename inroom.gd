extends Area2D

var entered = false

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D and body.is_in_group("Player"):
		entered = true

func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D and body.is_in_group("Player"):
		entered = false

func _process(delta: float) -> void:
	if entered: 
		get_tree().change_scene_to_file("res://housepika2.tscn")
