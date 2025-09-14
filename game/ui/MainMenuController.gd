extends Control

var status_label = null

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main menu loaded")
	setup_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func setup_menu():
	print("Setting up main menu...")
	
	# Get the buttons container
	var container = get_node("ButtonsContainer")
	if container == null:
		print("Error: ButtonsContainer not found!")
		return
	
	# Get status label
	status_label = get_node("StatusLabel")
	if status_label != null:
		status_label.text = "Status: Ready"
	else:
		print("Warning: StatusLabel not found!")
	
	# Create buttons
	var play_button = Button.new()
	play_button.text = "Play Game"
	play_button.pressed.connect(_on_play_pressed)
	play_button.size = Vector2(200, 40)
	container.add_child(play_button)
	
	var settings_button = Button.new()
	settings_button.text = "Settings"
	settings_button.pressed.connect(_on_settings_pressed)
	settings_button.size = Vector2(200, 40)
	container.add_child(settings_button)
	
	var deck_builder_button = Button.new()
	deck_builder_button.text = "Deck Builder"
	deck_builder_button.pressed.connect(_on_deck_builder_pressed)
	deck_builder_button.size = Vector2(200, 40)
	container.add_child(deck_builder_button)
	
	var test_battle_button = Button.new()
	test_battle_button.text = "Test Battle"
	test_battle_button.pressed.connect(_on_test_battle_pressed)
	test_battle_button.size = Vector2(200, 40)
	container.add_child(test_battle_button)
	
	var exit_button = Button.new()
	exit_button.text = "Exit"
	exit_button.pressed.connect(_on_exit_pressed)
	exit_button.size = Vector2(200, 40)
	container.add_child(exit_button)

func _on_play_pressed():
	print("Play button pressed")
	update_status("切换到游戏场景...")
	# This is where you would load your card game scene
	# get_tree().change_scene_to_file("res://godotCardParallax-7315a5cf17ffd24b024e3963/scenes/MainGame.tscn")

func _on_settings_pressed():
	print("Settings button pressed")
	update_status("切换到设置场景...")
	# This is where you would open settings
	# get_tree().change_scene_to_file("res://godotCardParallax-7315a5cf17ffd24b024e3963/scenes/ui/SettingsMenu.tscn")

func _on_deck_builder_pressed():
	print("Deck Builder button pressed")
	update_status("切换到卡组构建器...")
	# This is where you would open the deck builder

func _on_test_battle_pressed():
	print("Test Battle button pressed")
	update_status("切换到测试战斗场景...")
	var error = get_tree().change_scene_to_file("res://scenes/battle/TestBattle.tscn")
	if error != OK:
		print("Error changing scene: ", error)
		update_status("场景切换失败: " + str(error))

func _on_exit_pressed():
	print("Exit button pressed")
	update_status("退出游戏...")
	get_tree().quit()

func update_status(message):
	if status_label != null:
		status_label.text = "Status: " + message
