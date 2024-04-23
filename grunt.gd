extends Area2D

var entered = false
var animation_names = ["IdleLeft", "IdleUp", "IdleRight", "IdleDown"]
var move_direction = Vector2.ZERO
var idle_timer = 1.0
var idle_interval = 2.0

func _on_body_entered(body: CharacterBody2D):
	entered = true

func _on_body_exited(body):
	entered = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if entered:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().change_scene_to_file("res://gruntfight.tscn")
		play_random_idle_animation()

		# Update the idle timer only when the character is idle
		if move_direction == Vector2.ZERO:
			idle_timer += delta
			if idle_timer >= idle_interval:
				change_idle_animation()
				idle_timer = 0.0
	else:
		# Reset animation and timer when the player character is not nearby
		move_direction = Vector2.ZERO
		idle_timer = 1.0
		$AnimationPlayer.stop()

func play_random_idle_animation():
	if move_direction == Vector2.ZERO:
		$AnimationPlayer.play(animation_names[randi() % animation_names.size()])

func change_idle_animation():
	var current_animation_index = animation_names.find($AnimationPlayer.current_animation)
	var next_animation_index = (current_animation_index + 1) % animation_names.size()
	$AnimationPlayer.play(animation_names[next_animation_index])
