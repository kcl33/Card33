extends Node

# 卡牌类型枚举
enum CardType {
	MONSTER,     # 怪兽卡
	SPELL,       # 法术卡
	POLICY,      # 政策卡
	COMPONENT    # 组件卡
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

# 位置枚举（主要用于怪兽卡）
enum Position {
	ATTACK,           # 表侧攻击表示
	DEFENSE,          # 表侧守备表示
	FACE_DOWN_ATTACK, # 里侧攻击表示
	FACE_DOWN_DEFENSE # 里侧守备表示
}

# 组件类型枚举
enum ComponentType {
	WEAPON,      # 武器组件
	MOBILITY,    # 移动组件
	DEFENSE,     # 防御组件
	UTILITY      # 实用组件
}

# 卡牌基本信息
var id = ""
var card_name = ""        # 修复：使用card_name而不是name以避免与Node.name冲突
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
var position = Position.FACE_DOWN_ATTACK  # 默认为里侧攻击表示

# 组件卡特有属性
var component_type = null  # 组件类型
var target_unit = null     # 目标单位（用于组件卡）

# 超载相关属性
var overload_cost = 0      # 超载费用
var overload_effect = ""   # 超载效果描述

# 组装相关属性
var is_assembled = false   # 是否已组装
var components = []        # 已安装的组件列表

# 卡牌效果
var effects = []          # 卡牌效果列表

# 设置卡牌表示形式
func set_position(new_position):
	position = new_position

# 翻转卡牌（里侧变表侧，表侧变里侧）
func flip():
	match position:
		Position.ATTACK:
			position = Position.FACE_DOWN_ATTACK
		Position.DEFENSE:
			position = Position.FACE_DOWN_DEFENSE
		Position.FACE_DOWN_ATTACK:
			position = Position.ATTACK
		Position.FACE_DOWN_DEFENSE:
			position = Position.DEFENSE

# 获取攻击力（考虑组件加成）
func get_attack():
	var total_attack = attack
	for component in components:
		if component.component_type == ComponentType.WEAPON:
			total_attack += 500
		elif component.component_type == ComponentType.MOBILITY:
			total_attack += 100
	return total_attack

# 获取守备力（考虑组件加成）
func get_defense():
	var total_defense = defense
	for component in components:
		if component.component_type == ComponentType.DEFENSE:
			total_defense += 300
		elif component.component_type == ComponentType.MOBILITY:
			total_defense -= 100
	return total_defense
