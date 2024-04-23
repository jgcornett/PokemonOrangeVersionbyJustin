extends Node

func _ready():
	pass

var databasePokeMons = {
	0: {
		"Name": "Sentret",
		"Frame": 0,
		"Health": 35,
		"MaxHealth": 35,
		"Level": 5,
		"Exp": 0,
		"MaxExp": 10,
		"Attack": 46,
		"Defense": 34,
		"Special": 35,
		"Scene": preload("res://Sprites/gFAF5b7uyTfDhfewIcmpEVus.png"),
		"Attacks": {
			0: {
				"Name": "Scratch",
				"Power": 40,
				"Type": "Normal",
				"Accuracy": 80
			},
			1: {
				"Name": "Quick Attack",
				"Power": 30,
				"Type": "Normal",
				"Accuracy": 100
			},
			# Add more attacks as needed
		}
	},
	# Add more Pokémon entries as needed
}

# var selectedPokeMon = {


# pass

# }
