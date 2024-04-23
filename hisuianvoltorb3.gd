extends Area2D

const SPEED = 140.0
const JUMP_VELOCITY = -400.0
const TILE_SIZE = 16
const GRID_SIZE = 16

var move_direction = Vector2.ZERO
var wander_timer = 0.0
var wander_time = 0.0
enum Direction {LEFT, RIGHT}

func _ready():
	move_direction = Vector2(1, 0)  # Start by facing right
	start_wandering()

func _process(delta):
	# Move the character
	position += move_direction * SPEED * delta

	# Update wander timer
	wander_timer += delta

	if wander_timer >= wander_time:
		start_wandering()
		wander_timer = 0.0

func start_wandering():
	wander_time = randf_range(1.0, 3.0)

	# Choose a random direction
	var rand_direction = randi() % 2  # 0 or 1 for left or right
	match rand_direction:
		0:
			move_direction = Vector2(1, 0)  # Right
		1:
			move_direction = Vector2(-1, 0)  # Left

	handle_movement()

func handle_movement():
	if move_direction.x > 0:  # Moving right
		$AnimationPlayer.play("WalkRight")
	elif move_direction.x < 0:  # Moving left
		$AnimationPlayer.play("WalkLeft")
	else:
		$AnimationPlayer.play("Idle")  # Idle animation when not moving

func _on_Area2D_area_entered(area):
	if area.is_in_group("obstacle"):  # Assuming obstacles are in a group named "obstacle"
		move_direction *= -1  # Change direction when colliding with an obstacle
