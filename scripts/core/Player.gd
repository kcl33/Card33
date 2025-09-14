extends Node

# 玎家基本分（生命值）
var life_points = 8000

# 护甲值
var armor = 0

# 当前费用点数
var cost_points = 0

# 费用点数上限
var max_cost_points = 12

# 额外点数（用于额外召唤）
var extra_points = 2

# 玩家卡组
var deck = []

# 玩家手牌
var hand = []

# 玩家墓地
var graveyard = []

# 玩家除外区
var banished = []

# 额外卡组
var extra_deck = []

# 每回合通常召唤次数（通常为1次）
var normal_summon_count = 1

# 玩家场上的卡牌 (前场5格 + 后场5格 + 额外区域1格)
var field = {
	"front_row": [null, null, null, null, null],
	"back_row": [null, null, null, null, null],
	"extra_zone": null
}

func _init():
	pass

# 回合开始时调用的方法
func start_turn():
	# 增加费用点数（默认每回合增加1点）
	cost_points = min(cost_points + 1, max_cost_points)
	
	# 恢复额外点数
	extra_points = min(extra_points + 2, 4)  # 最多4点额外点数
	
	# 恢复通常召唤次数
	normal_summon_count = 1

# 抽卡方法
func draw_card(count = 1):
	for i in range(count):
		if deck.size() > 0:
			var card = deck.pop_front()
			hand.append(card)
		else:
			# 卡组抽空，手牌进入虚空状态
			# 这里可以添加虚空效果处理
			pass

# 支付费用方法
func pay_cost(cost):
	if cost_points >= cost:
		cost_points -= cost
		return true
	return false

# 支付额外点数方法
func pay_extra_cost(cost):
	if extra_points >= cost:
		extra_points -= cost
		return true
	return false

# 从场上移除卡牌的辅助函数
func remove_card_from_field(card):
	# 在前场查找
	for i in range(field.front_row.size()):
		if field.front_row[i] == card:
			field.front_row[i] = null
			return
	
	# 在后场查找
	for i in range(field.back_row.size()):
		if field.back_row[i] == card:
			field.back_row[i] = null
			return
	
	# 在额外区域查找
	if field.extra_zone == card:
		field.extra_zone = null