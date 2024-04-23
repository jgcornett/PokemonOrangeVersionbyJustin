extends Control

@onready var first_screen = $redtalk4
@onready var next1 = $Button
@onready var next2 = $Button2
@onready var next_3 = $Button3

# Called when the node enters the scene tree for the first time.
func _ready():
	first_screen.visible = false
	next2.visible = false
	$redtalk3.visible = true
	next_3.visible = false
	$redtalk5.visible = false
	$redtalk2.visible = false
	$Button4.visible = false
	$redtalk6.visible = false
	$redtalk8.visible = false
	$Button5.visible = false
	$Button6.visible = false
	$redtalk7.visible = false
	$redtalk9.visible = false
	$redtalk10.visible = false
	$Button7.visible = false
	$redtalk11.visible = false
	$redtalk12.visible = false
	$Button8.visible = false
	$Button9.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	first_screen.visible = false
	next1.visible = false
	next2.visible = true
	$redtalk5.visible = true
	$Button4.visible = false


func _on_button_2_pressed():
	$redtalk5.visible = false
	next2.visible = false
	next_3.visible = true
	$redtalk6.visible = true
	$Button.visible = false
	next1.visible = false
	$redtalk7.visible = false
	$Button4.visible = false
	
func _on_button_3_pressed():
	next_3.visible = false
	$redtalk6.visible = false
	$redtalk7.visible = true
	$Button4.visible = true

func _on_button_4_pressed():
	get_tree().change_scene_to_file("res://mewtwofight.tscn")
	$redtalk7.visible = false
	$Button4.visible = false
	$redtalk8.visible = true
	$Button5.visible = true
	$Button6.visible = true
	

func _on_button_5_pressed():
	$redtalk11.visible = true
	$Button8.visible = true
	$redtalk8.visible = false
	$Button5.visible = false
	$Button6.visible = false

func _on_button_6_pressed():
	$Button6.visible = false
	$Button5.visible = false
	$redtalk10.visible = true
	$Button7.visible = true

func _on_button_7_pressed():
	$redtalk8.visible = true
	$Button5.visible = true
	$Button6.visible = true
	$redtalk10.visible = false
	$Button7.visible = false


func _on_button_8_pressed():
	$redtalk12.visible = true
	$redtalk11.visible = false
	$Button8.visible = false
	$Button9.visible = true


func _on_button_9_pressed():
	get_tree().change_scene_to_file("res://RedSceneIceCave2.tscn")
