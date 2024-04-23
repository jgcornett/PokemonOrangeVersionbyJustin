extends Control

var player_speed = 10
var enemy_speed = 13
var primarina_type = "water"
var pikachu_type = "electric"
var thunder_shock_type = "electric"
var water_gun_type = "water"

# Pikachu stats
var pikachu_attack = 20
var pikachu_defense = 15
var pikachu_special_attack = 25
var pikachu_special_defense = 20
var pikachu_level = 5

# Primarina stats
var primarina_attack = 18
var primarina_defense = 16
var primarina_special_attack = 45
var primarina_special_defense = 25
var primarina_level = 5

var player_hp = 50
var enemy_hp = 45

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
	$battlemenu/GridContainer/QuickAttack.visible = false
	$Panel.visible = true
	$Panel/Button.visible = true
	$Panel/run.visible = false
	$Label.visible = true
	$background/pikachusprite1.visible = true
	$background/primarinasprite1.visible = true
	$Label2.visible = false
	$Panel/exit.visible = false
	$Panel/Button2.visible = false

	# Display the message indicating Primarina's appearance
	$Label.text = "Primarina appeared...\nSelect your move!"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_action_complete and enemy_action_complete:
		switch_turns()

func _on_run_pressed():
	print("Changing scene to map.tscn...")
	get_tree().change_scene_to_file("res://map.tscn")

func _on_button_pressed():
	if is_player_turn:
		$battlemenu.visible = true  # Show battle menu only when it's the player's turn
	else:
		$Label.text = "Enemy's turn..."
		# AI selects its move
		enemy_ai_select_move()

# Player's move: Thunder Shock
func _on_thunder_shock_pressed():
	if is_player_turn:
		$battlemenu.visible = false
		$Panel.visible = false
		
		# Set the base message for Thunder Shock
		var message = "Pikachu used Thunder Shock!"
		var critical_hit = false
		var damage = 0
		
		# Check if Thunder Shock misses
		var miss_chance = 0.0
		if turn_count == 0:  # If it's the first turn
			miss_chance = 0.0  # Set higher miss chance for the first turn
		
		if randf() < miss_chance:
			message = "Pikachu missed!"
			# Don't update enemy's HP if Thunder Shock misses
		else:
			# Calculate special damage
			
			# Introduce a 10% chance for a critical hit
			if randf() < 0.1:  # 10% chance
				damage = calculate_special_damage(pikachu_special_attack, primarina_special_defense, 40, pikachu_level, 1.0) * 1.1  # Increase damage by 10% for critical hit
				message = "Critical hit!\n" + message
				critical_hit = true
			else:
				# Calculate normal special damage
				var type_effectiveness = 1.0
				message = "It's super effective!"
				if thunder_shock_type == "electric" and primarina_type == "water":
					type_effectiveness = 1.3
				damage = calculate_special_damage(pikachu_special_attack, primarina_special_defense, 40, pikachu_level, type_effectiveness)
			
			# Decrease enemy's HP
			enemy_hp -= damage
			if enemy_hp <= 0:
				enemy_hp = 0
				message += "\nPrimarina fainted!"
				$background/primarinasprite1.visible = false
				# Set battle won flag
				battle_won = true
				# Display victory message
				message += "\nCongrats, you won!\nPress the button to exit."
				
		$Label.text = message
		$primarinahp.value = enemy_hp
		
		# Check if player lost the battle
		if !battle_won:
			# Start delay before Primarina's turn
			delay_timer.start()
		else:
			# Hide Pikachu and battle menu when player wins
			$background/pikachusprite1.visible = true
			$battlemenu.visible = false
			$Panel.visible = true
			$Panel/Button.visible = false
			$Panel/exit.visible = true

# AI function for Primarina's attack
func primarina_ai_attack():
	if enemy_action_complete or battle_won:
		print("Primarina's action is already complete or the battle is won. Skipping turn.")
		return

	print("Executing Primarina's AI attack")

	$Panel.visible = true
	$Panel/run.visible = false
	$battlemenu.visible = false
	$Panel/Button.visible = true

	# Randomly select move
	var move_index = randi() % 2  # Assuming Primarina has 2 moves
	match move_index:
		0:
			# Water Gun move
			$Label.text = "Primarina used Water Gun!"
			$Label2.visible = false
			water_gun_move()
		1:
			# Tail Whip move
			$Label.text = "Primarina used Snarl!"
			$Label2.visible = true  # Show Label2 when Snarl is used
			snarl_move()

# Water Gun move
func water_gun_move():
	var damage = calculate_special_damage(primarina_special_attack, pikachu_special_defense, 40, primarina_level, 1.0)
	var message = "Primarina used Water Gun!"
	var critical_hit = false
	var miss_chance = 0.1  # 10% chance to miss
	var miss_threshold = 0.001  # 0.1% chance to miss

	if randf() < miss_chance + miss_threshold:  # Adjusted to include the miss threshold
		message = "Primarina's Water Gun missed!"
	else:
		if randf() < 0.1:  # 10% chance for critical hit
			damage *= 1.1  # Increase damage by 10% for critical hit
			$Label.text = "Primarina used Water Gun!\nCritical Hit!"
			critical_hit = true

		player_hp -= damage
		if player_hp <= 0:
			player_hp = 0
			message += "\nPikachu fainted!"
			$battlemenu.visible = false
			$Panel/Button.visible = false
			$Panel/Button2.visible = true
			$background/pikachusprite1.visible = false
			

	$pikachuhp.value = player_hp
	enemy_action_complete = true

	if !critical_hit:
		$Label.text = message

# Snarl move
func snarl_move():
	pikachu_special_defense = int(pikachu_special_defense * 0.85)  # Lower Pikachu's Special Defense
	$Label.text = "Primarina used Snarl!"
	$Label2.visible = true
	$LabelHideTimer.start()
	$Panel/Button.visible = true # Hide the button temporarily

# Called when the timer times out
func _on_Timer_timeout():
	$Label2.text = "Pikachu's Special Defense was lowered!"
	$LabelHideTimer.start()
	$Panel/Button.visible = true  # Enable the button after a delay

# Function to calculate special damage
func calculate_special_damage(attack, defense, power, level, type_effectiveness):
	var effectiveness_multiplier = 1.0
	if primarina_type == "water":
		effectiveness_multiplier = 1.3
	
	var damage = (((2 * level + 10) * attack * power) / (defense * 250)) + 2
	damage *= type_effectiveness * effectiveness_multiplier
	
	return damage

# Function to calculate physical damage
func calculate_physical_damage(attack, defense, power, level):
	var damage = (((2 * level + 10) * attack * power) / (defense * 250)) + 2
	return damage
	
func calculate_special_damageai(attack, defense, power, level):
	var damage = (((2 * level + 10) * attack * power) / (defense * 250)) + 2
	return damage

# Function to enable player's moves
func enable_player_moves():
	if is_player_turn:
		$Panel.visible = true
		$Panel/run.visible = false
		$Panel/Button.visible = true
		$battlemenu.visible = true
	else:
		$Panel.visible = false
		$battlemenu.visible = false

# Function for the AI to select its move
func enemy_ai_select_move():
	primarina_ai_attack()

# Function to switch turns between player and enemy
func switch_turns():
	if is_player_turn:
		$Label.text = "Select your move!"
		player_action_complete = false
		$battlemenu.visible = true
	else:
		$Label.text = "Enemy's turn..."

# Called when the delay timer expires
func _on_delay_timer_timeout():
	if !delay_timer.is_stopped():
		delay_timer.stop()
	enemy_action_complete = false
	primarina_ai_attack()
	enemy_action_complete = true

func _input(event):
	if battle_won and event is InputEventAction and event.action == "ui_up":
		get_tree().change_scene_to_file("res://map_2_pt_2.tscn")

func _on_quick_attack_pressed():
	pass

func _on_label_hide_timer_timeout():
	$Label2.visible = false
	if !battle_won and player_hp <= 0:
		$Panel/Button2.visible = true
	else:
		$Panel/Button.visible = false

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://map_2_pt_2.tscn")

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://youlose.tscn")
