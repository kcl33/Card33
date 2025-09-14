extends Node2D

@onready var info_label = get_node("InfoLabel")

var game_controller
var battle_manager
var card_effect_system
var forge_cards
var hand_area_player1
var hand_area_player2
var field_area_player1
var field_area_player2
var field_visual_player1
var field_visual_player2
var mouse_controller
var draw_animation_player1
var draw_animation_player2
var player1_info_panel
var player2_info_panel

func _ready():
	print("加载测试战斗场景...")
	
	# 初始化游戏控制器已经通过@onready完成
	info_label.text = "初始化游戏控制器..."
	
	# 初始化游戏控制器
	game_controller = preload("res://scripts/core/GameController.gd").new()
	battle_manager = preload("res://scripts/battle/BattleManager.gd").new()
	card_effect_system = preload("res://scripts/core/CardEffect.gd").new()
	forge_cards = preload("res://scripts/core/ForgeCardExamples.gd").new()
	
	# 设置战斗结果回调
	battle_manager.set_battle_result_callback(battle_result_handler)
	
	# 初始化锻炉奇械卡组
	initialize_forge_deck()
	
	# 开始游戏
	game_controller.start_game()
	
	# 初始化UI区域
	initialize_ui_areas()
	
	# 初始化鼠标控制器
	mouse_controller = preload("res://scripts/ui/MouseController.gd").new(game_controller)
	mouse_controller.set_hand_areas(hand_area_player1, hand_area_player2)
	
	# 连接信号
	mouse_controller.connect("card_selected", _on_card_selected)
	mouse_controller.connect("card_deselected", _on_card_deselected)
	mouse_controller.connect("card_played", _on_card_played)
	
	# 初始化抽卡动画
	initialize_draw_animations()
	
	# 连接窗口大小变化信号
	get_viewport().connect("size_changed", Callable(self, "_on_window_resized"))
	_on_window_resized()
	
	# 更新标签
	update_info_label()

# 窗口大小变化时调整UI
func _on_window_resized():
	var viewport_size = get_viewport_rect().size
	
	# 调整信息标签位置到屏幕顶部中央
	info_label.position = Vector2(viewport_size.x/2 - info_label.size.x/2, 10)
	
	# 更新玩家信息面板
	update_player_info_panels()

# 初始化UI区域
func initialize_ui_areas():
	# 手牌区域 - 玩家1（自己）
	hand_area_player1 = preload("res://scripts/ui/HandArea.gd").new(game_controller.player1, true)  # true表示是玩家手牌
	hand_area_player1.position = Vector2(0, 720)  # 1080p底部
	add_child(hand_area_player1)
	
	# 手牌区域 - 玩家2（对手）
	hand_area_player2 = preload("res://scripts/ui/HandArea.gd").new(game_controller.player2, false)  # false表示是对手手牌
	hand_area_player2.position = Vector2(0, 0)  # 1080p顶部
	add_child(hand_area_player2)
	
	# 场上区域
	field_area_player1 = preload("res://scripts/ui/FieldArea.gd").new(game_controller.player1)
	field_area_player1.position = Vector2(0, 540)  # 1080p下半部分
	add_child(field_area_player1)
	
	field_area_player2 = preload("res://scripts/ui/FieldArea.gd").new(game_controller.player2)
	field_area_player2.position = Vector2(0, 180)  # 1080p上半部分
	add_child(field_area_player2)
	
	# 场地可视化区域
	field_visual_player1 = preload("res://scripts/ui/FieldVisual.gd").new(game_controller.player1)
	field_visual_player1.position = Vector2(0, 360)  # 1080p中部偏下
	add_child(field_visual_player1)
	
	field_visual_player2 = preload("res://scripts/ui/FieldVisual.gd").new(game_controller.player2)
	field_visual_player2.position = Vector2(0, 0)  # 1080p顶部
	add_child(field_visual_player2)
	
	# 创建玩家信息面板
	create_player_info_panels()

# 创建玩家信息面板
func create_player_info_panels():
	# 玩家1信息面板（左下角）
	player1_info_panel = PanelContainer.new()
	player1_info_panel.position = Vector2(10, 650)  # 左下角
	player1_info_panel.size = Vector2(200, 100)
	player1_info_panel.self_modulate = Color(0, 0, 0, 0.7)
	
	var player1_vbox = VBoxContainer.new()
	player1_vbox.set("theme_override_constants/separation", 2)
	player1_info_panel.add_child(player1_vbox)
	
	var player1_title = Label.new()
	player1_title.text = "玩家1"
	player1_title.add_theme_font_size_override("font_size", 16)
	player1_vbox.add_child(player1_title)
	
	add_child(player1_info_panel)
	
	# 玩家2信息面板（右上角）
	player2_info_panel = PanelContainer.new()
	player2_info_panel.position = Vector2(1070, 10)  # 右上角 (1080p宽度-210)
	player2_info_panel.size = Vector2(200, 100)
	player2_info_panel.self_modulate = Color(0, 0, 0, 0.7)
	
	var player2_vbox = VBoxContainer.new()
	player2_vbox.set("theme_override_constants/separation", 2)
	player2_info_panel.add_child(player2_vbox)
	
	var player2_title = Label.new()
	player2_title.text = "玩家2"
	player2_title.add_theme_font_size_override("font_size", 16)
	player2_vbox.add_child(player2_title)
	
	add_child(player2_info_panel)

# 更新玩家信息面板
func update_player_info_panels():
	if player1_info_panel == null or player2_info_panel == null:
		return
	
	# 清除旧的信息
	for child in player1_info_panel.get_children():
		child.queue_free()
	
	for child in player2_info_panel.get_children():
		child.queue_free()
	
	# 重新创建玩家1信息面板
	var player1_vbox = VBoxContainer.new()
	player1_vbox.set("theme_override_constants/separation", 2)
	player1_info_panel.add_child(player1_vbox)
	
	var player1_title = Label.new()
	player1_title.text = "玩家1"
	player1_title.add_theme_font_size_override("font_size", 16)
	player1_vbox.add_child(player1_title)
	
	var player1_lp = Label.new()
	player1_lp.text = "LP: " + str(game_controller.player1.life_points)
	player1_vbox.add_child(player1_lp)
	
	var player1_cost = Label.new()
	player1_cost.text = "费用: " + str(game_controller.player1.cost_points) + "/" + str(game_controller.player1.max_cost_points)
	player1_vbox.add_child(player1_cost)
	
	var player1_armor = Label.new()
	player1_armor.text = "护甲: " + str(game_controller.player1.armor_points)
	player1_vbox.add_child(player1_armor)
	
	# 重新创建玩家2信息面板
	var player2_vbox = VBoxContainer.new()
	player2_vbox.set("theme_override_constants/separation", 2)
	player2_info_panel.add_child(player2_vbox)
	
	var player2_title = Label.new()
	player2_title.text = "玩家2"
	player2_title.add_theme_font_size_override("font_size", 16)
	player2_vbox.add_child(player2_title)
	
	var player2_lp = Label.new()
	player2_lp.text = "LP: " + str(game_controller.player2.life_points)
	player2_vbox.add_child(player2_lp)
	
	var player2_cost = Label.new()
	player2_cost.text = "费用: " + str(game_controller.player2.cost_points) + "/" + str(game_controller.player2.max_cost_points)
	player2_vbox.add_child(player2_cost)
	
	var player2_armor = Label.new()
	player2_armor.text = "护甲: " + str(game_controller.player2.armor_points)
	player2_vbox.add_child(player2_armor)

# 初始化抽卡动画
func initialize_draw_animations():
	draw_animation_player1 = preload("res://scripts/ui/DrawCardAnimation.gd").new()
	draw_animation_player1.initialize(Vector2(900, 540), Vector2(540, 720))  # 从右侧中部到手牌
	draw_animation_player1.position = Vector2(0, 0)
	draw_animation_player1.connect("card_drawn", Callable(self, "_on_card_drawn_player1"))
	add_child(draw_animation_player1)
	
	draw_animation_player2 = preload("res://scripts/ui/DrawCardAnimation.gd").new()
	draw_animation_player2.initialize(Vector2(200, 180), Vector2(540, 180))  # 从左侧中部到手牌
	draw_animation_player2.position = Vector2(0, 0)
	draw_animation_player2.connect("card_drawn", Callable(self, "_on_card_drawn_player2"))
	add_child(draw_animation_player2)

# 初始化锻炉奇械卡组
func initialize_forge_deck():
	# 为玩家1创建锻炉奇械主题卡组
	game_controller.player1.deck.clear()
	game_controller.player2.deck.clear()
	
	# 添加基础单位
	for i in range(3):
		game_controller.player1.deck.append(forge_cards.create_walking_mech())
		game_controller.player2.deck.append(forge_cards.create_walking_mech())
	
	# 添加组件
	for i in range(2):
		game_controller.player1.deck.append(forge_cards.create_steam_fist())
		game_controller.player1.deck.append(forge_cards.create_rocket_treads())
		game_controller.player2.deck.append(forge_cards.create_steam_fist())
		game_controller.player2.deck.append(forge_cards.create_rocket_treads())
	
	# 添加高级单位
	game_controller.player1.deck.append(forge_cards.create_core_furnace_drive())
	game_controller.player2.deck.append(forge_cards.create_core_furnace_drive())
	
	# 添加法术
	game_controller.player1.deck.append(forge_cards.create_overload_steam_jet())
	game_controller.player1.deck.append(forge_cards.create_emergency_rebuild())
	game_controller.player1.deck.append(forge_cards.create_full_overload())
	game_controller.player2.deck.append(forge_cards.create_overload_steam_jet())
	game_controller.player2.deck.append(forge_cards.create_emergency_rebuild())
	game_controller.player2.deck.append(forge_cards.create_full_overload())
	
	# 洗牌
	game_controller.player1.deck.shuffle()
	game_controller.player2.deck.shuffle()

# 模拟抽卡
func simulate_draw_card():
	print("===================")
	print("模拟抽卡:")
	
	# 玩家1抽卡带动画
	if game_controller.player1.deck.size() > 0:
		var card = game_controller.player1.deck.pop_front()
		game_controller.player1.hand.append(card)
		draw_animation_player1.draw_card_animation(card)
	
	# 玩家2抽卡带动画
	if game_controller.player2.deck.size() > 0:
		var card = game_controller.player2.deck.pop_front()
		game_controller.player2.hand.append(card)
		draw_animation_player2.draw_card_animation(card)
	
	# 更新显示
	update_display()
	update_info_label()

func simulate_turn():
	print("===================")
	print("模拟一回合操作:")
	
	# 模拟完整回合的所有阶段
	for phase in range(6):
		game_controller.process_phase()
	
	print("回合操作模拟完成")
	print("玩家1生命值: " + str(game_controller.player1.life_points))
	print("玩家2生命值: " + str(game_controller.player2.life_points))
	print("")
	
	# 更新显示
	update_display()
	
	# 更新标签
	update_info_label()

func simulate_battle():
	print("===================")
	print("模拟战斗:")
	
	# 创建一些测试怪兽
	var monster1 = forge_cards.create_walking_mech()
	monster1.card_name = "测试步行机铠1"
	monster1.attack = 1500
	monster1.defense = 1200
	monster1.position = monster1.Position.ATTACK
	
	var monster2 = forge_cards.create_walking_mech()
	monster2.card_name = "测试步行机铠2"
	monster2.attack = 1200
	monster2.defense = 800
	monster2.position = monster2.Position.ATTACK
	
	# 将怪兽放置到场上
	game_controller.player1.field.front_row[0] = monster1
	game_controller.player2.field.front_row[0] = monster2
	
	# 更新场上显示
	field_area_player1.update_field()
	field_area_player2.update_field()
	field_visual_player1.update_field()
	field_visual_player2.update_field()
	
	# 开始战斗
	battle_manager.start_battle_phase(game_controller.player1, game_controller.player2)
	battle_manager.select_attacker(monster1)
	battle_manager.select_target(monster2)
	
	# 更新标签
	update_info_label()

func test_card_effect():
	print("===================")
	print("测试卡牌效果:")
	
	# 创建测试效果
	var effects = card_effect_system.create_test_effects()
	
	# 应用效果
	for effect in effects:
		card_effect_system.apply_effect(effect, game_controller.player1, game_controller.player2)
	
	print("应用效果完成")
	print("玩家1生命值: " + str(game_controller.player1.life_points))
	print("玩家2生命值: " + str(game_controller.player2.life_points))
	print("玩家1费用点数: " + str(game_controller.player1.cost_points) + "/" + str(game_controller.player1.max_cost_points))
	
	# 更新显示
	update_display()
	
	# 更新标签
	update_info_label()

func test_assemble_mech():
	print("===================")
	print("测试组装机制:")
	
	# 创建一个步行机铠和组件
	var mech = forge_cards.create_walking_mech()
	var fist = forge_cards.create_steam_fist()
	
	# 将卡牌添加到手牌
	game_controller.player1.hand.append(mech)
	game_controller.player1.hand.append(fist)
	
	# 玩家打出步行机铠
	game_controller.player1.play_card(mech)
	
	# 安装组件
	game_controller.player1.attach_component(fist, mech)
	
	# 更新显示
	update_display()
	
	print("组装测试完成")
	update_info_label()

# 测试遗物系统
func test_relic_system():
	print("===================")
	print("测试遗物系统:")
	
	# 添加一个遗物给玩家1
	var relic = game_controller.player1.relic_manager.get_random_relic()
	if relic != null:
		game_controller.player1.relic_manager.add_relic(game_controller.player1, relic)
		print("玩家1获得遗物: ", relic.get_relic_name())
	else:
		print("没有可用的遗物")
	
	# 模拟回合结束触发遗物效果
	game_controller.player1.on_turn_end()
	
	# 更新标签
	update_info_label()

# 更新所有显示
func update_display():
	hand_area_player1.update_hand()
	hand_area_player2.update_hand()
	field_area_player1.update_field()
	field_area_player2.update_field()
	field_visual_player1.update_field()
	field_visual_player2.update_field()
	update_player_info_panels()

func battle_result_handler(result):
	print("战斗结果: ", result)
	match result.type:
		"direct_attack":
			print("直接攻击造成 ", result.damage, " 点伤害")
			if result.game_over:
				print("游戏结束!")
		"monster_battle":
			print("怪兽战斗: ", result.message)

func update_info_label():
	var text = "回合: " + str(game_controller.turn_count) + \
			" 玩家1 LP: " + str(game_controller.player1.life_points) + \
			" 玩家2 LP: " + str(game_controller.player2.life_points) + \
			"\n空格:下一回合 B:模拟战斗 T:测试卡牌效果 A:测试组装 R:测试遗物 D:抽卡"
	info_label.text = text
	_on_window_resized()  # 重新居中标签

# 处理鼠标输入
func _input(event):
	mouse_controller.handle_mouse_input(event)

# 卡牌选择事件处理
func _on_card_selected(card):
	print("UI: 选择了卡牌 ", card.card_name)

# 卡牌取消选择事件处理
func _on_card_deselected():
	print("UI: 取消选择卡牌")

# 卡牌打出事件处理
func _on_card_played(card, position):
	print("UI: 打出卡牌 ", card.card_name, " 位置: ", position)
	# 更新场上显示
	field_area_player1.update_field()
	field_area_player2.update_field()
	field_visual_player1.update_field()
	field_visual_player2.update_field()

# 玩家1抽卡完成事件处理
func _on_card_drawn_player1(card):
	print("玩家1抽到了卡牌: ", card.card_name)
	# 更新手牌显示
	hand_area_player1.update_hand()
	field_visual_player1.update_field()

# 玩家2抽卡完成事件处理
func _on_card_drawn_player2(card):
	print("玩家2抽到了卡牌: ", card.card_name)
	# 更新手牌显示
	hand_area_player2.update_hand()
	field_visual_player2.update_field()

func _process(delta):
	# 处理键盘输入
	if Input.is_key_pressed(KEY_SPACE):
		simulate_turn()
	elif Input.is_key_pressed(KEY_B):
		simulate_battle()
	elif Input.is_key_pressed(KEY_T):
		test_card_effect()
	elif Input.is_key_pressed(KEY_A):
		test_assemble_mech()
	elif Input.is_key_pressed(KEY_R):
		test_relic_system()
	elif Input.is_key_pressed(KEY_D):
		simulate_draw_card()
