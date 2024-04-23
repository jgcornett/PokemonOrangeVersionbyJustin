extends CharacterBody2D


@onready var _focus = $focus
@onready var progress_bar = $ProgressBar

@export var MAX_HEALTH: float = 46

var health: float = 46:
	set(value):
		health = value
		_upgrade_progress_bar()
		# _play_animation()
		
func _upgrade_progress_bar():
	progress_bar.value = (health/MAX_HEALTH) * 100
	
func _play_animation():
	pass
	
func focus():
	_focus.show()
	
func unfocus():
	_focus.hide()
