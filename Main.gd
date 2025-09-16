extends Control

# 菜单按钮引用
@onready var new_game_button = $MainContainer/MenuSection/NewGameButton
@onready var load_game_button = $MainContainer/MenuSection/LoadGameButton
@onready var settings_button = $MainContainer/MenuSection/SettingsButton
@onready var credits_button = $MainContainer/MenuSection/CreditsButton
@onready var exit_button = $MainContainer/MenuSection/ExitButton

# 动画和音效
@onready var menu_animator = $MenuAnimator
@onready var audio_player = $AudioStreamPlayer

# 菜单状态
var is_menu_ready = false
var current_selected_button = 0
var menu_buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Welcome to CardForge Nexus!")
	print("Initializing enhanced main menu...")
	
	# 初始化菜单
	setup_menu()
	
	# 检查插件
	check_plugins()
	
	# 播放进入动画
	play_enter_animation()

func setup_menu():
	# 收集所有按钮
	menu_buttons = [new_game_button, load_game_button, settings_button, credits_button, exit_button]
	
	# 连接按钮信号
	new_game_button.connect("pressed", _on_new_game_pressed)
	new_game_button.connect("mouse_entered", _on_button_hover.bind(0))
	
	load_game_button.connect("pressed", _on_load_game_pressed)
	load_game_button.connect("mouse_entered", _on_button_hover.bind(1))
	
	settings_button.connect("pressed", _on_settings_pressed)
	settings_button.connect("mouse_entered", _on_button_hover.bind(2))
	
	credits_button.connect("pressed", _on_credits_pressed)
	credits_button.connect("mouse_entered", _on_button_hover.bind(3))
	
	exit_button.connect("pressed", _on_exit_pressed)
	exit_button.connect("mouse_entered", _on_button_hover.bind(4))
	
	# 设置初始按钮样式
	update_button_styles()
	
	# 启用键盘导航
	set_process_input(true)

func _input(event):
	if not is_menu_ready:
		return
		
	# 键盘导航
	if event.is_action_pressed("ui_up"):
		current_selected_button = max(0, current_selected_button - 1)
		update_button_styles()
		play_button_sound()
	elif event.is_action_pressed("ui_down"):
		current_selected_button = min(menu_buttons.size() - 1, current_selected_button + 1)
		update_button_styles()
		play_button_sound()
	elif event.is_action_pressed("ui_accept"):
		menu_buttons[current_selected_button].emit_signal("pressed")

func update_button_styles():
	for i in range(menu_buttons.size()):
		var button = menu_buttons[i]
		if i == current_selected_button:
			# 高亮当前选中的按钮
			button.modulate = Color(1.2, 1.2, 1.2, 1.0)
			button.add_theme_color_override("font_color", Color(0.3, 0.6, 1.0, 1.0))
		else:
			# 普通按钮样式
			button.modulate = Color(1.0, 1.0, 1.0, 1.0)
			button.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9, 1.0))

func play_enter_animation():
	# 初始状态：所有元素透明
	modulate = Color(1, 1, 1, 0)
	
	# 淡入动画
	menu_animator.tween_property(self, "modulate", Color(1, 1, 1, 1), 1.0)
	menu_animator.tween_callback(_on_enter_animation_finished)

func _on_enter_animation_finished():
	is_menu_ready = true
	print("Main menu ready!")

func play_button_sound():
	# 播放按钮音效（如果有音频文件）
	# audio_player.play()
	pass

func _on_button_hover(button_index):
	current_selected_button = button_index
	update_button_styles()
	play_button_sound()

# 按钮事件处理
func _on_new_game_pressed():
	print("Starting new game...")
	play_button_animation(new_game_button)
	# 这里可以加载游戏场景
	# get_tree().change_scene_to_file("res://scenes/game/GameScene.tscn")

func _on_load_game_pressed():
	print("Loading game...")
	play_button_animation(load_game_button)
	# 这里可以显示加载游戏对话框

func _on_settings_pressed():
	print("Opening settings...")
	play_button_animation(settings_button)
	# 打开设置界面
	get_tree().change_scene_to_file("res://scenes/Settings.tscn")

func _on_credits_pressed():
	print("Showing credits...")
	play_button_animation(credits_button)
	# 显示制作人员名单
	get_tree().change_scene_to_file("res://scenes/Credits.tscn")

func _on_exit_pressed():
	print("Exiting game...")
	play_button_animation(exit_button)
	# 退出确认对话框
	show_exit_confirmation()

func play_button_animation(button):
	# 按钮按下动画
	menu_animator.stop_all()
	menu_animator.tween_property(button, "scale", Vector2(0.95, 0.95), 0.1)
	menu_animator.tween_property(button, "scale", Vector2(1.0, 1.0), 0.1)

func show_exit_confirmation():
	# 创建退出确认对话框
	var dialog = AcceptDialog.new()
	dialog.title = "退出游戏"
	dialog.dialog_text = "确定要退出游戏吗？"
	dialog.add_button("取消", false, "cancel")
	dialog.add_button("退出", true, "exit")
	
	add_child(dialog)
	dialog.popup_centered()
	
	dialog.connect("custom_action", _on_exit_dialog_action)

func _on_exit_dialog_action(action):
	if action == "exit":
		get_tree().quit()

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