extends Node2D


var enemies: Array = []
var index: int = 0

func _ready():
	enemies = get_children()
	for i in enemies.size():
		enemies[i].position = Vector2(0, i*32)
		
	enemies[0].focus()
		
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		pass
	
func switch_focus(x,y):
	enemies[x].focus()
	enemies[y].unfocus()
	
