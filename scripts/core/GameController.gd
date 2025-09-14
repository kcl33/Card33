extends Node

var player1 = null
var player2 = null
var turn_count = 0
var current_player = null
var turn_phase = null
var game_over = false

func _init():
	# 初始化玩家
	player1 = preload("res://scripts/core/Player.gd").new()
	player2 = preload("res://scripts/core/Player.gd").new()
	turn_phase = preload("res://scripts/core/TurnPhase.gd").new()
	
	# 默认玩家1先手
	current_player = player1

func start_game():
	print("游戏开始!")
	turn_count = 1
	
	# 首回合抽4张卡
	current_player.draw_card(4)
	
	# 显示初始状态
	print("回合 " + str(turn_count) + " 开始")
	print("当前玩家费用点数: " + str(current_player.cost_points) + "/" + str(current_player.max_cost_points))
	print("当前玩家手牌数: " + str(current_player.hand.size()))

func next_turn():
	# 切换玩家
	if current_player == player1:
		current_player = player2
	else:
		current_player = player1
		turn_count += 1
	
	# 新回合开始
	current_player.start_turn()
	
	# 抽卡（非首回合抽1张）
	current_player.draw_card(1)
	
	# 重置回合阶段
	turn_phase.current_phase = turn_phase.Phase.DRAW
	
	print("回合 " + str(turn_count) + " 开始")
	print("当前玩家费用点数: " + str(current_player.cost_points) + "/" + str(current_player.max_cost_points))
	print("当前玩家手牌数: " + str(current_player.hand.size()))

func process_phase():
	match turn_phase.current_phase:
		turn_phase.Phase.DRAW:
			print("进入抽卡阶段")
			# 首回合已经在start_game中处理过抽卡，这里不需要重复抽卡
			
		turn_phase.Phase.STANDBY:
			print("进入准备阶段")
			
		turn_phase.Phase.MAIN_1:
			print("进入主要阶段1")
			
		turn_phase.Phase.BATTLE:
			print("进入战斗阶段")
			
		turn_phase.Phase.MAIN_2:
			print("进入主要阶段2")
			
		turn_phase.Phase.END:
			print("进入结束阶段")
			# 回合结束，进入下一回合
			next_turn()
			return
	
	# 进入下一阶段
	turn_phase.next_phase()

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