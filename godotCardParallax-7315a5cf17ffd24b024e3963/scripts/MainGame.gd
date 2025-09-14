class_name MainGame
extends Node2D

var game_manager: GameManager
var story_manager: StoryManager
var tutorial_manager: TutorialManager
var card_data_manager: CardDataManager
var save_manager: SaveManager
var stats_manager: StatsManager
var achievement_manager: AchievementManager
var player1: Player
var player2: Player

@onready var game_ui = $GameUI
@onready var game_menu = $GameMenu

func _ready():
	init_game()

func init_game():
	# 创建管理系统
	game_manager = GameManager.new()
	story_manager = StoryManager.new()
	tutorial_manager = TutorialManager.new()
	card_data_manager = CardDataManager.new()
	save_manager = SaveManager.new()
	stats_manager = StatsManager.new()
	achievement_manager = AchievementManager.new()
	add_child(card_data_manager)
	add_child(save_manager)
	add_child(stats_manager)
	add_child(achievement_manager)
	
	# 连接成就系统信号
	achievement_manager.connect("achievement_unlocked", self, "_on_achievement_unlocked")
	
	# 尝试加载存档
	var save_loaded = save_manager.load_game(story_manager, achievement_manager)
	if not save_loaded:
		# 如果没有存档，初始化剧情
		story_manager.initialize_story()
	
	# 加载统计数据
	save_manager.load_statistics(stats_manager)
	
	# 创建玩家
	player1 = Player.new()
	player2 = Player.new()
	
	# 设置玩家角色
	player1.character_name = Character.create_main_character().name
	player2.character_name = Character.create_dad_character().name
	
	# 创建初始卡组
	create_initial_decks()
	
	# 设置游戏
	game_manager.setup_game(player1, player2)
	
	# 连接信号
	game_manager.connect("phase_changed", self, "_on_game_phase_changed")
	game_manager.connect("game_ended", self, "_on_game_ended")
	story_manager.connect("story_event_triggered", self, "_on_story_event")
	tutorial_manager.connect("tutorial_completed", self, "_on_tutorial_completed")
	
	# 设置UI
	game_ui.setup_ui(game_manager, player1, player2, tutorial_manager)
	game_ui.connect("open_menu_requested", self, "_on_open_menu_requested")
	
	# 设置游戏菜单
	game_menu.connect("resume_requested", self, "_on_resume_requested")
	game_menu.connect("main_menu_requested", self, "_on_main_menu_requested")
	game_menu.connect("quit_requested", self, "_on_quit_requested")
	
	# 开始教程（如果尚未完成）
	if not story_manager.story_progress.get("tutorial_completed", false):
		tutorial_manager.start_tutorial()

func create_initial_decks():
	# 为玩家创建初始卡组
	var starter_cards = [
		"warrior",
		"warrior",
		"warrior",
		"mage",
		"mage",
		"fireball",
		"fireball",
		"shield"
	]
	
	# 为玩家1创建卡组
	for card_name in starter_cards:
		var card = card_data_manager.create_card_from_template(card_name)
		if card:
			player1.deck.append(card)
	
	# 为玩家2创建卡组
	for card_name in starter_cards:
		var card = card_data_manager.create_card_from_template(card_name)
		if card:
			player2.deck.append(card)
	
	# 洗牌
	player1.deck.shuffle()
	player2.deck.shuffle()

func _on_game_phase_changed(phase):
	# 处理游戏阶段变化
	match phase:
		GameManager.GamePhase.START_PHASE:
			if tutorial_manager.is_tutorial_active() and tutorial_manager.get_current_step() == 0:
				tutorial_manager.complete_current_step()
		GameManager.GamePhase.DRAW_PHASE:
			if tutorial_manager.is_tutorial_active() and tutorial_manager.get_current_step() == 1:
				tutorial_manager.complete_current_step()
		GameManager.GamePhase.MANA_PHASE:
			if tutorial_manager.is_tutorial_active() and tutorial_manager.get_current_step() == 2:
				tutorial_manager.complete_current_step()

func _on_game_ended(winner):
	# 处理游戏结束
	if winner == player1:
		print("玩家获胜！")
		if tutorial_manager.is_tutorial_active():
			tutorial_manager.complete_current_step()
		# 更新统计数据
		stats_manager.record_game_result(true)
		# 检查成就
		achievement_manager.check_achievement("win_game")
		achievement_manager.check_achievement("play_games", stats_manager.games_played)
	else:
		print("对手获胜！")
		# 更新统计数据
		stats_manager.record_game_result(false)
	
	# 保存统计数据
	save_manager.save_statistics(stats_manager)

func _on_story_event(event_name):
	# 处理剧情事件
	print("剧情事件: ", event_name)
	
	# 保存游戏进度
	save_manager.save_game(story_manager, achievement_manager)

func _on_tutorial_completed():
	# 教程完成
	story_manager.complete_tutorial()
	print("教程已完成！")
	
	# 检查成就
	achievement_manager.check_achievement("complete_tutorial")
	
	# 保存游戏进度
	save_manager.save_game(story_manager, achievement_manager)

func _on_open_menu_requested():
	game_menu.show_menu()

func _on_resume_requested():
	game_menu.hide_menu()

func _on_main_menu_requested():
	# 返回主菜单的逻辑
	print("返回主菜单")
	
	# 保存游戏进度
	save_manager.save_game(story_manager, achievement_manager)

func _on_quit_requested():
	# 退出前保存游戏
	save_manager.save_game(story_manager, achievement_manager)
	save_manager.save_statistics(stats_manager)
	get_tree().quit()

func _on_achievement_unlocked(achievement):
	# 处理成就解锁
	print("解锁成就: %s - %s" % [achievement.name, achievement.description])
	# 这里可以添加UI通知等
	
	# 保存成就状态
	save_manager.save_game(story_manager, achievement_manager)