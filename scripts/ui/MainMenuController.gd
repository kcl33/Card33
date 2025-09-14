extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main menu loaded")
	setup_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup_menu():
	print("Setting up main menu...")
	
	# Create title
	var title = get_node("Title")
	title.set("theme_override_font_sizes/font_size", 32)
	
	# Create a simple UI with options
	var play_button = Button.new()
	play_button.text = "Play Game"
	play_button.connect("pressed", self, "_on_play_pressed")
	play_button.set_position(Vector2(300, 200))
	play_button.set_size(Vector2(200, 50))
	add_child(play_button)
	
	var settings_button = Button.new()
	settings_button.text = "Settings"
	settings_button.connect("pressed", self, "_on_settings_pressed")
	settings_button.set_position(Vector2(300, 270))
	settings_button.set_size(Vector2(200, 50))
	add_child(settings_button)
	
	var deck_builder_button = Button.new()
	deck_builder_button.text = "Deck Builder"
	deck_builder_button.connect("pressed", self, "_on_deck_builder_pressed")
	deck_builder_button.set_position(Vector2(300, 340))
	deck_builder_button.set_size(Vector2(200, 50))
	add_child(deck_builder_button)
	
	var exit_button = Button.new()
	exit_button.text = "Exit"
	exit_button.connect("pressed", self, "_on_exit_pressed")
	exit_button.set_position(Vector2(300, 410))
	exit_button.set_size(Vector2(200, 50))
	add_child(exit_button)

func _on_play_pressed():
	print("Play button pressed")
	# This is where you would load your card game scene
	get_tree().change_scene("res://godotCardParallax-7315a5cf17ffd24b024e3963/scenes/MainGame.tscn")

func _on_settings_pressed():
	print("Settings button pressed")
	# This is where you would open settings
	get_tree().change_scene("res://godotCardParallax-7315a5cf17ffd24b024e3963/scenes/ui/SettingsMenu.tscn")

func _on_deck_builder_pressed():
	print("Deck Builder button pressed")
	# This is where you would open the deck builder

func _on_exit_pressed():
	print("Exit button pressed")
	get_tree().quit()