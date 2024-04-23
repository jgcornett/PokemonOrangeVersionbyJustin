extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.visible = true
	$Button.visible = true
	$TextureRect2.visible = false
	$Button2.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	$TextureRect.visible = false
	$Button.visible = false
	$TextureRect2.visible = true
	$Button2.visible = true


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://introscene.tscn")
