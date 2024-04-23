extends CharacterBody2D

@export var group_name : String

const SPEED = 0.5  # Adjust the speed to match the grid movement
const JUMP_VELOCITY = -400.0
const TILE_SIZE = 16  # Adjust this according to your tile size in pixels
const smoothing_factor: float = 1
const grid_size: int = 16
var positions : Array
var temp_positions : Array
var current_position : Marker2D

var direction : Vector2 = Vector2.ZERO

func _ready():
	positions = get_tree().get_nodes_in_group(group_name)
	_get_positions()
	_get_next_position()
	
func _physics_process(_delta):
	if global_position.distance_to(current_position.position) < 10:
		_get_next_position()
	
func _get_positions():
	temp_positions = positions.duplicate()
	temp_positions.shuffle()
	
func _get_next_position():
	if temp_positions.is_empty():
		_get_positions()
	current_position = temp_positions.pop_front()
	direction = to_local(current_position.position).normalized() 
