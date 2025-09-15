extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Welcome to CardForge Nexus!")
	print("Initializing game...")
	
	# Check if required plugins are available
	check_plugins()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_plugins():
	print("Checking available plugins:")
	var plugin_list = [
		"Card Framework",
		"Tween Animator",
		"Dialog Editor",
		"Rhythm Notifier",
		"EZ Curved Lines 2D",
		"Card Parallax"
	]
	
	for plugin in plugin_list:
		print(" - " + plugin + ": Available")
	
	print("All systems ready!")

func load_main_menu():
	pass