extends CharacterBody2D

const SPEED = 90.0
const JUMP_VELOCITY = -400.0
const TILE_SIZE = 16
const grid_size = 16

var move_direction = Vector2.ZERO
var wander_timer = 0.0
var wander_time = 0.0
enum Direction { UP, DOWN, LEFT, RIGHT, IDLE }

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
	elif move_direction.y > 0:  # Moving down
		$AnimationPlayer.play("WalkDown")
	elif move_direction.y < 0:  # Moving up
		$AnimationPlayer.play("WalkUp")
	else:
		$AnimationPlayer.play("Idle")  # Idle animation when not moving

func start_wandering():
	wander_timer = 0.0
	wander_time = randf_range(1.0, 3.0)

	var rand_direction = randi() % 4
	match rand_direction:
		0:
			move_direction = Vector2(1, 0)  # Right
		1:
			move_direction = Vector2(-1, 0)  # Left
		2:
			move_direction = Vector2(0, 1)  # Down
		3:
			move_direction = Vector2(0, -1)  # Up

func _on_CharacterBody2D_body_entered(body: Node):
	if body is CharacterBody2D:
		# Reverse the movement direction upon collision with another character
		move_direction *= -1
