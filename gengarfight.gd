extends Control

var player_speed = 10
var enemy_speed = 13
var gengar_type = "ghost"
var pikachu_type = "electric"
var thunder_shock_type = "electric"
var shadow_ball_type = "water"

# Pikachu stats
var pikachu_attack = 20
var pikachu_defense = 15
var pikachu_special_attack = 25
var pikachu_special_defense = 20
var pikachu_level = 5

# Primarina stats
var gengar_attack = 10
var gengar_defense = 25
var gengar_special_attack = 40
var gengar_special_defense = 35
var gengar_level = 10

var player_hp = 55
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
	$Panel.visible = true
	$Panel/Button.visible = true
	$Panel/run.visible = false
	$Label.visible = true
	$background/pikachusprite1.visible = true
	$background/gengarsprite1.visible = true
	$Label2.visible = false
	$Panel/exit.visible = false
	$Panel/Button2.visible = false

	# Display the message indicating Primarina's appearance
	$Label.text = "An evil gengar appeared\nSelect your move!"

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

# Player's move: Nuzzle
# Player's move: Nuzzle
func _on_nuzzle_pressed():
	if is_player_turn:
		$battlemenu.visible = false
		$Panel.visible = false
		
		# Set the base message for Nuzzle
		var message = "Pikachu used Nuzzle!"
		var critical_hit = false
		
		# Calculate damage and apply special defense reduction
		var damage = calculate_special_damage(pikachu_special_attack, gengar_special_defense, 40, pikachu_level, 1.0) * 0.7
		
		# Decrease enemy's HP
		enemy_hp -= damage
		
		# Lower Raticate's special defense
		gengar_special_defense -= int(gengar_special_defense * 0.1)
		
		# Display the message about Raticate's special defense being lowered
		_on_timer_2_timeout()
		
		if enemy_hp <= 0:
			enemy_hp = 0
			message += "\nGengar fainted!"
			$background/gengarsprite1.visible = false
			# Set battle won flag
			battle_won = true
			# Display victory message
			message += "\nCongrats, you won!\nPress the button to exit."
				
		# Update UI and flags
		$Label.text = message
		$raticatehp.value = enemy_hp
		
		# Check if player lost the battle
		if !battle_won:
			# Start delay before Raticate's turn
			delay_timer.start()
		else:
			# Hide Pikachu and battle menu when player wins
			$background/pikachusprite1.visible = true
			$battlemenu.visible = false
			$Panel.visible = true
			$Panel/Button.visible = false
			$Panel/exit.visible = true
	else:
		# It's not the player's turn
		print("It's not the player's turn to attack.")

# Player's move: Thunder Shock
func _on_thunder_shock_pressed():
	if is_player_turn:
		$battlemenu.visible = false
		$Panel.visible = false
		
		# Set the base message for Thunder Shock
		var message = "Pikachu used Thunder Shock!"
		var critical_hit = false
		var damage = 0
		
		# Calculate special damage
		# Introduce a 10% chance for a critical hit
		if randf() < 0.1:  # 10% chance
			damage = calculate_special_damage(gengar_special_attack, gengar_special_defense, 40, pikachu_level, 1.0) * 1.1  # Increase damage by 10% for critical hit
			message = "Critical hit!\n" + message
			critical_hit = true
		else:
			# Calculate normal special damage
			var type_effectiveness = 1.0
			if thunder_shock_type == "electric" and gengar_type == "water":
				type_effectiveness = 1.3
			damage = calculate_special_damage(gengar_special_attack, gengar_special_defense, 40, pikachu_level, type_effectiveness)
		
		# Decrease enemy's HP
		enemy_hp -= damage
		if enemy_hp <= 0:
			enemy_hp = 0
			message += "\nGengar lost!"
			$background/gengarsprite1.visible = false
			# Set battle won flag
			battle_won = true
			# Display victory message
			message += "\nCongrats, you won!\nPress the button to exit."
				
		$Label.text = message
		$raticatehp.value = enemy_hp
		
		# Check if player lost the battle
		if !battle_won:
			# Start delay before Raticate's turn
			delay_timer.start()
		else:
			# Hide Pikachu and battle menu when player wins
			$background/pikachusprite1.visible = true
			$battlemenu.visible = false
			$Panel.visible = true
			$Panel/Button.visible = false
			$Panel/exit.visible = true
	else:
		# It's not the player's turn
		print("It's not the player's turn to attack.")


# AI function for Primarina's attack
func gengar_ai_attack():
	if enemy_action_complete or battle_won:
		print("Gengar's action is already complete or the battle is won. Skipping turn.")
		return

	print("Executing AI attack")

	$Panel.visible = true
	$Panel/run.visible = false
	$battlemenu.visible = false
	$Panel/Button.visible = true

	# Randomly select move
	var move_index = randi() % 3  # Assuming Gengar has 3 moves
	match move_index:
		0:
			# Shadow Ball move
			$Label.text = "Gengar used Shadow Ball!"
			$Label2.visible = false
			shadow_ball_move()
		1:
			# Shadow Punch move
			$Label.text = "Gengar used Shadow Punch!"
			$Label2.visible = false
			shadow_punch_move()
		2:
			# Calm Mind move
			$Label.text = "Gengar used Calm Mind!\nHis special attack and defense rose!"
			$Label2.visible = false
			calm_mind_move()

# Shadow Ball move
func shadow_ball_move():
	var damage = calculate_special_damage(gengar_special_attack, pikachu_special_defense, 40, gengar_level, 1.0)  # Assuming type effectiveness is 1.0
	var message = "Gengar used Shadow Ball!"
	var miss_chance = 0.4  # 40% chance to miss

	if randf() < miss_chance:
		message = "Gengar's Shadow Ball missed!"
	else:
		player_hp -= damage
		if player_hp <= 0:
			player_hp = 0
			message += "\nPikachu fainted!"

	$pikachuhp.value = player_hp
	enemy_action_complete = true
	$Label.text = message

# Shadow Punch move
func shadow_punch_move():
	var damage = calculate_physical_damage(gengar_attack, pikachu_defense, 80, gengar_level)
	var message = "Gengar used Shadow Punch!"
	var miss_chance = 0.5  # 50% chance to miss

	if randf() < miss_chance:
		message = "Gengar's Shadow Punch missed!"
	else:
		player_hp -= damage
		if player_hp <= 0:
			player_hp = 0
			message += "\nPikachu fainted!"

	$pikachuhp.value = player_hp
	enemy_action_complete = true
	$Label.text = message

# Calm Mind move
func calm_mind_move():
	# Increase Gengar's special attack and special defense by 10%
	gengar_special_attack += 10
	gengar_special_defense += 10
	enemy_action_complete = true

# Called when the timer times out
func _on_Timer_timeout():
	$LabelHideTimer.start()
	$Panel/Button.visible = true

# Function to calculate special damage
func calculate_special_damage(attack, defense, power, level, type_effectiveness):
	var effectiveness_multiplier = 1.0
	if gengar_type == "water":
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
	gengar_ai_attack()

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
	if !delay_timer.is_stopped():
		delay_timer.stop()
	enemy_action_complete = false
	gengar_ai_attack()
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
	get_tree().change_scene_to_file("res://gengarscene2.tscn")

func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://youlose.tscn")






func _on_timer_2_timeout():
	$Label2.text = "Raticate's special defense was lowered!"