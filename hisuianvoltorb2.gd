extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const TILE_SIZE = 16
const GRID_SIZE = 16

var move_direction = Vector2.ZERO
var wander_timer = 0.0
var wander_time = 0.0

enum Direction { LEFT, RIGHT }

func _ready():
	move_direction = Vector2(1, 0)  # Start by facing right
	start_wandering()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += JUMP_VELOCITY * delta

	handle_movement()

	move_and_slide()

	wander_timer += delta
	if wander_timer >= wander_time:
		start_wandering()

func handle_movement():
	velocity = move_direction * SPEED

	if move_direction.x > 0:  # Moving right
		$AnimationPlayer.play("WalkRight")
	elif move_direction.x < 0:  # Moving left
		$AnimationPlayer.play("WalkLeft")
	else:
		$AnimationPlayer.play("Idle")  # Idle animation when not moving

func start_wandering():
	wander_timer = 0.0
	wander_time = randf_range(1.0, 3.0)

	var rand_direction = randi() % 2  # Adjusted to only select left or right
	match rand_direction:
		0:
			move_direction = Vector2(1, 0)  # Right
		1:
			move_direction = Vector2(-1, 0)  # Left

func _on_collision_shape_2d_body_entered(body):
	if body.is_in_group("Wall"):
		if move_direction.x > 0:
			move_direction = Vector2(-1, 0)  # Move left
		else:
			move_direction = Vector2(1, 0)   # Move right
		start_wandering()  # Call start_wandering immediately after changing direction	

