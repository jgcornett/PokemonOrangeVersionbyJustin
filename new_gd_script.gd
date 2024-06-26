extends Control

var player_speed = 10
var enemy_speed = 13

# Pikachu stats
var pikachu_attack = 20
var pikachu_defense = 15
var pikachu_special_attack = 25
var pikachu_special_defense = 20
var pikachu_level = 5

# Sentret stats
var raticate_attack = 18
var raticate_defense = 16
var raticate_special_attack = 22
var raticate_special_defense = 18
var raticate_level = 5

var player_hp = 50
var enemy_hp = 56

var is_player_turn = true

var player_action_complete = false
var enemy_action_complete = false

var battle_won = false

var turn_count = 0  # Variable to track the number of turns
var max_turns = 3  # Maximum number of turns to increase accuracy

@onready var delay_timer: Timer = $DelayTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize UI visibility
	$battlemenu.visible = false
	$bigmenu.visible = true
	$bigmenu/fight.visible = true
	$bigmenu/restart.visible = false
	$Label.visible = true
	$background/pikachusprite1.visible = true
	$background/raticatesprite1.visible = true
	$background/metapodsprite1.visible = false
	$metapodhp.visible = false
	$Label2.visible = false
	$bigmenu/exit.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_action_complete and enemy_action_complete:
		switch_turns()

func _on_run_pressed():
	print("Changing scene to map.tscn...")
	get_tree().change_scene_to_file("res://map.tscn")


# AI function for Sentret's attack
func raticate_ai_attack():
	if enemy_action_complete or battle_won:
		print("Raticate's action is already complete or the battle is won. Skipping turn.")
		return

	print("Executing Raticates's AI attack")


	# Randomly select move
	var move_index = randi() % 2  # Assuming Sentret has 2 moves
	match move_index:
		0:
			# Tackle move
			$Label.text = "Raticate used Tackle!"
			$Label2.visible = false
			tackle_move()
		1:
			# Tail Whip move
			$Label.text = "Sentret used Hyper Fang!"
			$Label2.visible = true  # Show Label2 when Tail Whip is used
			hyper_fang_move()

# Tackle move
func tackle_move():
	var damage = calculate_physical_damage(raticate_attack, pikachu_defense, 50, raticate_level)
	var message = "Raticate used Tackle!"
	var critical_hit = false
	var miss_chance = 0.1  # 10% chance to miss
	var miss_threshold = 0.001  # 0.1% chance to miss

	if randf() < miss_chance + miss_threshold:  # Adjusted to include the miss threshold
		message = "Sentret's Tackle missed!"
	else:
		if randf() < 0.1:  # 10% chance for critical hit
			damage *= 1.1  # Increase damage by 10% for critical hit
			$Label.text = "Sentret used Tackle!\nCritical Hit!"
			critical_hit = true

		player_hp -= damage
		if player_hp <= 0:
			player_hp = 0
			message += "\nPikachu fainted!"

	$pikachuhp.value = player_hp
	enemy_action_complete = true

	if not critical_hit:
		$Label.text = message

# Tail Whip move
func hyper_fang_move():
	pikachu_defense = int(player_hp * 0.5)
	$Label.text = "Raticate used Hyper Fang!"
	$Label2.visible = true
	$LabelHideTimer.start()

# Called when the timer times out

# Function to calculate special damage
func calculate_special_damage(attack, defense, power, level):
	var damage = (((2 * level + 10) * attack * power) / (defense * 250)) + 2
	return damage

# Function to calculate physical damage
func calculate_physical_damage(attack, defense, power, level):
	var damage = (((2 * level + 10) * attack * power) / (defense * 250)) + 2
	return damage

# Function to enable player's moves
func enable_player_moves():
	if is_player_turn:
		$bigmenu.visible = true
		$bigmenu/fight.visible = true
		$battlemenu.visible = true
	else:
		$bigmenu.visible = false
		$battlemenu.visible = false

# Function for the AI to select its move
func enemy_ai_select_move():
	raticate_ai_attack()

# Function to switch turns between player and enemy
func switch_turns():
	if is_player_turn:
		$Label.text = "Select your move!"
		player_action_complete = false
		$battlemenu.visible = false
	else:
		$Label.text = "Enemy's turn..."

# Called when the delay timer expires
func _on_delay_timer_timeout():
	if not delay_timer.is_stopped():
		delay_timer.stop()
	enemy_action_complete = false
	raticate_ai_attack()
	enemy_action_complete = true

func _input(event):
	if battle_won and event is InputEventAction and event.action == "ui_up":
		get_tree().change_scene_to_file("res://map.tscn")

func _on_quick_attack_pressed():
	pass

func _on_label_hide_timer_timeout():
	$Label2.visible = false
	if not battle_won:
		$bigmenu/fight.visible = true
	else:
		$bigmenu/fight.visible = false
		$Label.text = "Congrats, you won!\nPress Enter to exit."

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://map.tscn")

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://introscene.tscn")
	#(make this to where button2 only appears when you lose!) (why does my restart(button2) keep popping up in the middle of the battle)



func _on_fight_pressed():
	$battlemenu.visible = false
	$bigmenu.visible = false
	$bigmenu/fight.visible = false
	if is_player_turn:
		$Label.text = "Select your move!"
		# Enable player's moves
		enable_player_moves()
	else:
		$Label.text = "Enemy's turn..."
		# AI selects its move
		enemy_ai_select_move()


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://introscene.tscn")


func _on_thundershock_pressed():
		if is_player_turn:
			$battlemenu.visible = false
			$bigmenu.visible = false
		
		# Set the base message for Thunder Shock
		var message = "Pikachu used Thunder Shock!"
		var critical_hit = false
		
		# Check if Thunder Shock misses
		var miss_chance = 0.9
		if not player_action_complete:  # If it's the first turn
			miss_chance = 0.0  # Set higher miss chance for the first turn
		
		if randf() < miss_chance:
			message = "Pikachu missed!"
			# Don't update enemy's HP if Thunder Shock misses
		else:
			# Calculate special damage
			var damage = 0
			
			# Introduce a 10% chance for a critical hit
			if randf() < 0.1:  # 10% chance
				damage = calculate_special_damage(raticate_special_attack, raticate_special_defense, 40, pikachu_level) * 1.1  # Increase damage by 10% for critical hit
				message = "Critical hit!\n" + message
				critical_hit = true
			else:
				# Calculate normal special damage
				damage = calculate_special_damage(pikachu_special_attack, raticate_special_defense, 40, pikachu_level)
			
			# Decrease enemy's HP
			enemy_hp -= damage
			if enemy_hp <= 0:
				enemy_hp = 0
				message += "\nRaticate fainted!"
				$background/raticatesprite1.visible = false
				$raticatehp.visible = false
				$background/metapodsprite1.visible = false
				$metapodhp.visible = false
				# Set battle won flag
				battle_won = true
				# Display victory message
				message += "\nCongrats, you won!\nPress the button to exit."
				
		$Label.text = message
		$raticatehp.value = enemy_hp
		
		# Check if player lost the battle
		if !battle_won:
			# Start delay before Sentret's turn
			delay_timer.start()
		else:
			# Hide Pikachu and battle menu when player wins
			$background/pikachusprite1.visible = true
			$battlemenu.visible = false
			$bigmenu.visible = true
			$bigmenu/fight.visible = false
			$bigmenu/exit.visible = true


func _on_nuzzle_pressed():
	pass # Replace with function body.


func _on_timer_timeout():
		#$Label2.text = "Your DEF was lowered!"
	$LabelHideTimer.start()
	$bigmenu/fight.visible = true


func _on_button_label_timer_timeout():
	pass # Replace with function body.
