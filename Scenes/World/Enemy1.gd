extends Area2D

# Declare variables
var character_name : String = "Sentret"
var lvl : int = 5
var entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_body_entered(body: CharacterBody2D):
	entered = true


func _on_body_exited(body):
	entered = false


func _process(delta):
	if entered == true:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file("res://map2.tscn")
		
