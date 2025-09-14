extends Node

# 遗物类型枚举
enum RelicType {
	STARTING,      # 起始遗物
	COMMON,        # 普通遗物
	UNCOMMON,      # 罕见遗物
	RARE,          # 稀有遗物
	BOSS,          # BOSS遗物
	SHOP,          # 商店遗物
	EVENT          # 事件遗物
}

# 遗物稀有度枚举
enum Rarity {
	COMMON,        # 普通
	UNCOMMON,      # 罕见
	RARE           # 稀有
}

# 遗物触发时机枚举
enum TriggerTiming {
	GAME_START,    # 游戏开始时
	TURN_START,    # 回合开始时
	TURN_END,      # 回合结束时
	CARD_PLAYED,   # 打出卡牌时
	CARD_DRAWN,    # 抽卡时
	DAMAGE_TAKEN,  # 受到伤害时
	DAMAGE_DEALT,  # 造成伤害时
	MONSTER_SUMMONED, # 召唤怪兽时
	BATTLE_START,  # 战斗开始时
	BATTLE_END     # 战斗结束时
}

# 遗物基本属性
var id = ""
var relic_name = ""
var description = ""
var relic_type = RelicType.COMMON
var rarity = Rarity.COMMON
var trigger_timing = []  # 触发时机数组

# 遗物效果
var effects = []

# 是否已激活
var is_active = false

func _init():
	pass

# 激活遗物效果
func activate(player):
	is_active = true
	# 子类应该重写这个方法来实现具体效果
	pass

# 触发遗物效果
func trigger(player, context=null):
	if not is_active:
		return
	
	# 子类应该重写这个方法来实现具体效果
	pass

# 获取遗物描述
func get_description():
	return description

# 获取遗物名称
func get_relic_name():
	return relic_name

# 获取遗物ID
func get_id():
	return id