extends Node

# 卡牌类型枚举
enum CardType {
	MONSTER,     # 怪兽卡
	SPELL,       # 法术卡
	POLICY       # 政策卡
}

# 法术卡子类型枚举
enum SpellType {
	INSTANT,     # 即时法术
	CHANTED      # 咏唱法术
}

# 召唤类型枚举
enum SummonType {
	NORMAL,      # 通常召唤
	TRIBUTE,     # 上级召唤
	SPECIAL,     # 特殊召唤
	EXTRA        # 额外召唤
}

# 表示形式枚举
enum Position {
	ATTACK,      # 攻击表示
	DEFENSE      # 守备表示
}

# 卡牌基本信息
var id = ""
var name = ""
var description = ""
var card_type = CardType.MONSTER
var spell_type = null
var cost = 0              # 费用
var extra_cost = 0        # 额外费用

# 怪兽卡特有属性
var attack = 0
var defense = 0
var level = 1

# 召唤相关信息
var summon_type = null    # 召唤类型
var position = null       # 表示形式

# 卡牌效果
var effects = []          # 卡牌效果列表

func _init():
	pass

# 添加效果
func add_effect(effect):
	effects.append(effect)

# 获取所有效果
func get_effects():
	return effects