extends Node

# 遗物管理器
var relics = []  # 玩家当前拥有的遗物
var relic_pool = []  # 遗物池

# 引用遗物类
var Relic = preload("res://scripts/core/Relic.gd")
# var BurningBloodRelic = preload("res://scripts/core/BurningBloodRelic.gd")

func _init():
	initialize_relic_pool()

# 初始化遗物池
func initialize_relic_pool():
	# 添加一些示例遗物到池中
	var relic1 = preload("res://scripts/core/BurningBloodRelic.gd").new()
	relic_pool.append(relic1)
	
	# 可以添加更多遗物...

# 添加遗物到玩家
func add_relic(player, relic):
	relics.append(relic)
	relic.activate(player)
	print("获得遗物: ", relic.get_relic_name())

# 移除遗物
func remove_relic(relic):
	if relics.has(relic):
		relics.erase(relic)
		print("失去遗物: ", relic.get_relic_name())

# 根据类型获取遗物
func get_relics_by_type(type):
	var result = []
	for relic in relics:
		if relic.relic_type == type:
			result.append(relic)
	return result

# 根据稀有度获取遗物
func get_relics_by_rarity(rarity):
	var result = []
	for relic in relics:
		if relic.rarity == rarity:
			result.append(relic)
	return result

# 获取所有遗物
func get_all_relics():
	return relics

# 触发特定时机的遗物效果
func trigger_relics_by_timing(player, timing, context=null):
	for relic in relics:
		if relic.trigger_timing.has(timing):
			relic.trigger(player, context)

# 随机获取一个遗物（用于奖励）
func get_random_relic(rarity_filter=null):
	var available_relics = relic_pool
	if rarity_filter != null:
		available_relics = []
		for relic in relic_pool:
			if relic.rarity == rarity_filter:
				available_relics.append(relic)
	
	if available_relics.size() > 0:
		return available_relics[randi() % available_relics.size()]
	
	return null

# 根据稀有度权重随机获取遗物
func get_random_relic_weighted():
	# 简化的权重系统：普通(60%), 罕见(30%), 稀有(10%)
	var rarity_roll = randf()
	var rarity_filter
	
	if rarity_roll < 0.6:
		rarity_filter = Relic.Rarity.COMMON
	elif rarity_roll < 0.9:
		rarity_filter = Relic.Rarity.UNCOMMON
	else:
		rarity_filter = Relic.Rarity.RARE
	
	return get_random_relic(rarity_filter)