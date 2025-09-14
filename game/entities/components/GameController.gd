extends Node

# 游戏阶段枚举
enum GamePhase {
	DRAW_PHASE,      # 抽卡阶段
	STANDBY_PHASE,   # 准备阶段
	MAIN_PHASE_1,    # 主要阶段1
	BATTLE_PHASE,    # 战斗阶段
	MAIN_PHASE_2,    # 主要阶段2
	END_PHASE        # 结束阶段
}

# 游戏状态
var turn_count = 1
var current_phase = GamePhase.DRAW_PHASE
var current_player = 1
var game_over = false

# 玩家对象
@export
var player1 = null
var player2 = null

func _init():
	# 初始化玩家
	player1 = Player.new(1)
	player2 = Player.new(2)
	
	# 初始化玩家牌组（示例）
	initialize_decks()

func start_game():
	print("游戏开始！")
	
	# 触发遗物效果：游戏开始时
	player1.relic_manager.on_game_start(player1)
	player2.relic_manager.on_game_start(player2)
	
	# 初始抽卡
	for i in range(5):
		player1.draw_card()
		player2.draw_card()
	
	# 设置初始阶段
	current_phase = GamePhase.DRAW_PHASE
	current_player = 1
	turn_count = 1
	
	print("第", turn_count, "回合开始")

# 处理阶段
func process_phase():
	if game_over:
		return
	
	match current_phase:
		GamePhase.DRAW_PHASE:
			process_draw_phase()
		GamePhase.STANDBY_PHASE:
			process_standby_phase()
		GamePhase.MAIN_PHASE_1:
			process_main_phase_1()
		GamePhase.BATTLE_PHASE:
			process_battle_phase()
		GamePhase.MAIN_PHASE_2:
			process_main_phase_2()
		GamePhase.END_PHASE:
			process_end_phase()

# 初始化牌组
func initialize_decks():
	# 为玩家1创建示例卡牌
	for i in range(20):
		var card = Card.new()
		card.card_name = "测试卡牌" + str(i)
		card.card_type = card.CardType.MONSTER
		card.attack = 1000 + i * 100
		card.defense = 800 + i * 100
		card.cost = 1 + (i % 5)
		player1.deck.append(card)
		
		# 为玩家2创建示例卡牌
		card = Card.new()
		card.card_name = "测试卡牌" + str(i)
		card.card_type = card.CardType.MONSTER
		card.attack = 1000 + i * 100
		card.defense = 800 + i * 100
		card.cost = 1 + (i % 5)
		player2.deck.append(card)
	
	# 洗牌
	player1.deck.shuffle()
	player2.deck.shuffle()

# 抽卡阶段
func process_draw_phase():
	print("=== 抽卡阶段 ===")
	var current_player_obj = player1 if current_player == 1 else player2
	
	# 回合开始时触发遗物效果
	current_player_obj.on_turn_start()
	
	# 抽一张卡
	current_player_obj.draw_card()
	
	# 增加费用点数
	current_player_obj.cost_points = min(current_player_obj.cost_points + 1, current_player_obj.max_cost_points)
	
	# 进入准备阶段
	current_phase = GamePhase.STANDBY_PHASE

# 准备阶段
func process_standby_phase():
	print("=== 准备阶段 ===")
	# 这里可以处理一些准备阶段的效果
	current_phase = GamePhase.MAIN_PHASE_1

# 主要阶段1
func process_main_phase_1():
	print("=== 主要阶段1 ===")
	# 这里玩家可以进行主要操作
	current_phase = GamePhase.BATTLE_PHASE

# 战斗阶段
func process_battle_phase():
	print("=== 战斗阶段 ===")
	# 这里处理战斗逻辑
	current_phase = GamePhase.MAIN_PHASE_2

# 主要阶段2
func process_main_phase_2():
	print("=== 主要阶段2 ===")
	# 这里玩家可以进行第二轮主要操作
	current_phase = GamePhase.END_PHASE

# 结束阶段
func process_end_phase():
	print("=== 结束阶段 ===")
	# 重置回合相关状态
	var current_player_obj = player1 if current_player == 1 else player2
	current_player_obj.normal_summon_used = false
	
	# 回合结束时触发遗物效果
	current_player_obj.on_turn_end()
	
	# 回合结束时恢复额外点数
	current_player_obj.extra_points = min(current_player_obj.extra_points + 2, 4)  # 最多4点额外点数
	
	# 切换玩家
	if current_player == 1:
		current_player = 2
	else:
		current_player = 1
		turn_count += 1
	
	# 进入下一回合的抽卡阶段
	current_phase = GamePhase.DRAW_PHASE
	print("第", turn_count, "回合开始")

# 检查游戏是否结束
func check_game_over():
	if player1.life_points <= 0:
		print("玩家2获胜!")
		game_over = true
		return true
	elif player2.life_points <= 0:
		print("玩家1获胜!")
		game_over = true
		return true
	return false
