extends CharacterBody2D

class_name Player

@export var grid_size: int = 16 # The size of each grid cell
@export var speed: int = 80 # Adjust the speed to fit the grid
@export var smoothing_factor: float = 0.099 # Adjust the smoothing factor to control the smoothness


var target_grid_position: Vector2 = Vector2.ZERO
var donald_in_range = false
var hitler_in_range = false
var jewfro1_in_range = false
var xxnightphantom_in_range = false
var solosis1_in_range = false # Added solosis1_in_range variable
var yungoos1_in_range = false
var klawf_in_range = false
var mrmime1_in_range = false
var brandon_in_range = false

enum Direction { UP, DOWN, LEFT, RIGHT, IDLE } # Added IDLE direction

var current_direction: Direction = Direction.IDLE # Initialize direction as IDLE


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var interact_pressed = Input.is_action_just_pressed("ui_accept") # Check if interact button is pressed

	# Determine the direction based on input
	if input_direction.length_squared() > 0:
		if abs(input_direction.x) > abs(input_direction.y):
			input_direction.y = 0
		else:
			input_direction.x = 0

		velocity = input_direction * speed

		# Determine the current direction
		if input_direction.y > 0:
			current_direction = Direction.UP
		elif input_direction.y < 0:
			current_direction = Direction.DOWN
		elif input_direction.x < 0:
			current_direction = Direction.LEFT
		elif input_direction.x > 0:
			current_direction = Direction.RIGHT
	else:
		velocity = Vector2.ZERO
		current_direction = Direction.IDLE # Set direction to IDLE when no input

	# If interact button is pressed and any NPC is in range, initiate interaction
	if interact_pressed && (donald_in_range or hitler_in_range or jewfro1_in_range or xxnightphantom_in_range or solosis1_in_range or yungoos1_in_range): # Added solosis1_in_range to interaction check
		ui_interact() # Call the interaction function

	# Here, you can add other input handling logic if needed


func ui_interact():
	# Implement your interaction logic here
	if donald_in_range:
		start_dialogue_with_donald_trump()
	elif xxnightphantom_in_range:
		start_dialogue_with_xxnightphantom()
	elif solosis1_in_range: # Added handling for solosis1
		start_dialogue_with_solosis1()
	elif yungoos1_in_range:
		start_dialogue_with_yungoos1()
	elif klawf_in_range:
		start_dialogue_with_yungoos1()
	elif mrmime1_in_range:
		start_dialogue_with_mrmime1()
	elif brandon_in_range:
		start_dialogue_with_brandon()

func start_dialogue_with_donald_trump():
	# Implement dialogue initiation logic here
	print("Initiating dialogue with Donald Trump")



func start_dialogue_with_xxnightphantom():
	# Implement dialogue initiation logic here for xxnightphantom
	print("Initiating dialogue with xxnightphantom")

func start_dialogue_with_solosis1():
	# Implement dialogue initiation logic here for solosis1
	print("Initiating dialogue with solosis1")
	# Load and display dialogue for solosis1

func start_dialogue_with_yungoos1():
	# Implement dialogue initiation logic here for yungoos
	print("Initiating dialogue with yungoos1")
	# Load and display dialogue for yungoos
	
func start_dialogue_with_klawf():
	print("Initating dialogue with Klawf")
	
func start_dialogue_with_mrmime1():
	print("Initating dialogue with Mr. Mime")
	
func start_dialogue_with_brandon():
	print("Initating dialogue with Mr. Mime")


func _physics_process(delta):
	get_input()
	
	if donald_in_range == true:
		if Input.is_action_just_pressed("ui_accept"):
				DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "main")
				return
	elif hitler_in_range == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://hitler1.dialogue"), "hitler1")
			return
	elif jewfro1_in_range == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://jewfro1.dialogue"), "jewfro1")
			return
	elif xxnightphantom_in_range == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://xxnightphantom1.dialogue"), "xxnightphantom1")
			return
	elif solosis1_in_range == true: # Added handling for solosis1
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://solosis1.dialogue"), "solosis1")
			return
	elif yungoos1_in_range == true:  # Assuming you have a variable yungoos_in_range similar to other NPCs
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://yungoos1.dialogue"), "yungoos1")
			return
	elif klawf_in_range == true:	
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://klawf.dialogue"), "klawf")
			return
	elif mrmime1_in_range == true:	
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://mrmime1.dialogue"), "mrmime1")
			return
	elif brandon_in_range == true:
		if Input.is_action_just_pressed("ui_accept"):
			DialogueManager.show_example_dialogue_balloon(load("res://brandon.dialogue"), "brandon")
			return

	# Calculate the target grid position based on the current position and velocity
	target_grid_position = position + velocity * delta

	# Snap the target grid position to the nearest grid cell
	target_grid_position = target_grid_position.snapped(Vector2(grid_size, grid_size))

	# Calculate the distance to the target grid position
	var distance_to_target = target_grid_position - position

	# Move only if the distance to the target grid position is greater than the grid size
	if distance_to_target.length() >= grid_size:
		position = target_grid_position 
	else:
		# Smoothly move the character towards the target grid position using exponential smoothing
		position += distance_to_target * smoothing_factor

	# Play appropriate animations based on the movement direction
	match current_direction:
		Direction.UP:
			$AnimationPlayer.play("WalkDown")
		Direction.DOWN:
			$AnimationPlayer.play("WalkUp")
		Direction.LEFT:
			$AnimationPlayer.play("WalkLeft")
		Direction.RIGHT:
			$AnimationPlayer.play("WalkRight")

	move_and_slide()


func ui_menu():
	# Replace this with your specific interaction code based on the context
	print(MenuBar)


func ui_save():
	# Logic to save game
	print()


func _on_detection_area_body_entered(body):
	if body.has_method("donaldtrump"):
		donald_in_range = true
	elif body.has_method("xxnightphantom"):
		xxnightphantom_in_range = true
	elif body.has_method("solosis1"): # Added detection for solosis1
		solosis1_in_range = true
	elif body.has_method("yungoos1"):
		yungoos1_in_range = true
	elif body.has_method("klawf"):
		klawf_in_range = true
	elif body.has_method("mrmime1"):
		mrmime1_in_range = true
	elif body.has_method("brandon"):
		brandon_in_range = true

func player():
	pass

func _on_detection_area_body_exited(body):
	if body.has_method("donaldtrump"):
		donald_in_range = false
	elif body.has_method("xxnightphantom"):
		xxnightphantom_in_range = false
	elif body.has_method("solosis1"): # Added detection for solosis1
		solosis1_in_range = false
	elif body.has_method("yungoos1"):
		yungoos1_in_range = false
	elif body.has_method("klawf"):
		klawf_in_range = false
	elif body.has_method("mrmime1"):
		mrmime1_in_range = false
	elif body.has_method("brandon"):
		brandon_in_range = false
	
func _on_housecave_transition_point_body_enetered(body):
	pass
	
func _on_housecave_transition_point_body_exited(body):
	pass
# func _on_battle_spawn_body_entered(body):
	# pass # Replace with function body.
	
func _ready():
	NavigationManager.on_trigger_player_spawn.connect(_on_spawn)
	
func _on_spawn(position: Vector2, direction: String):
	global_position = position
	$AnimationPlayer.play("Idle" + direction)
	$AnimationPlayer.stop()
	
func battlme():
	pass
