extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	$background.visible = false
	emit_signal("battle_started", self, "init")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func init(character_name, lvl):
	visible =  true
	$AnimationPlayer.play("fadein")
	get_tree().paused = true
	$background/Panel/Label.text = "A wild %s lvl %s appears" %[character_name, lvl]

## func init(character)
