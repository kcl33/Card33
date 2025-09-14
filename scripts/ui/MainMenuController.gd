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
	
	# Create a simple UI with options
	var play_button = Button.new()
	play_button.text = "Play Game"
	play_button.connect("pressed", self, "_on_play_pressed")
	play_button.set_position(Vector2(300, 200))
	add_child(play_button)
	
	var settings_button = Button.new()
	settings_button.text = "Settings"
	settings_button.connect("pressed", self, "_on_settings_pressed")
	settings_button.set_position(Vector2(300, 250))
	add_child(settings_button)
	
	var exit_button = Button.new()
	exit_button.text = "Exit"
	exit_button.connect("pressed", self, "_on_exit_pressed")
	exit_button.set_position(Vector2(300, 300))
	add_child(exit_button)

func _on_play_pressed():
	print("Play button pressed")
	# This is where you would load your card game scene

func _on_settings_pressed():
	print("Settings button pressed")
	# This is where you would open settings

func _on_exit_pressed():
	print("Exit button pressed")
	get_tree().quit()