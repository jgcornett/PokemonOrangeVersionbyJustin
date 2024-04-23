extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/next2.visible = false
	$TextureRect2.visible = true
	$TextureRect3.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_next_pressed():
	$Panel/next.visible = false
	$Panel/next2.visible = true
	$TextureRect2.visible = false
	$TextureRect3.visible = true


func _on_next_2_pressed():
	get_tree().change_scene_to_file("res://RedSceneIceCave3.tscn")
