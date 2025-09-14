extends Node

# 创建锻炉奇械主题的示例卡牌

# 创建步行机铠（基础单位）
func create_walking_mech():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "步行机铠"
	card.card_type = card.CardType.MONSTER
	card.cost = 2
	card.attack = 800
	card.defense = 1200
	card.description = "基础的锻炉奇械单位，拥有不错的防御力"

	# 添加卡牌脚本
	var script = preload("res://scripts/core/cards/example_cards/WalkingMechScript.gd").new(card)
	card.set_card_script(script)
	
	return card

# 创建蒸汽拳套（攻击型组件）
func create_steam_fist():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "蒸汽拳套"
	card.card_type = card.CardType.COMPONENT
	card.component_type = card.ComponentType.WEAPON
	card.cost = 1
	card.description = "增加攻击力的武器组件"
	return card

# 创建火箭履带（机动型组件）
func create_rocket_treads():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "火箭履带"
	card.card_type = card.CardType.COMPONENT
	card.component_type = card.ComponentType.MOBILITY
	card.cost = 1
	card.description = "提高机动性的移动组件"
	return card

# 创建核心熔炉驱动（高级单位）
func create_core_furnace_drive():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "核心熔炉驱动"
	card.card_type = card.CardType.MONSTER
	card.cost = 4
	card.attack = 1800
	card.defense = 1000
	card.description = "高级的锻炉奇械单位，拥有强大的攻击力"
	return card

# 创建过载蒸汽喷射（法术卡）
func create_overload_steam_jet():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "过载蒸汽喷射"
	card.card_type = card.CardType.SPELL
	card.cost = 3
	card.description = "对敌方场上所有怪兽造成800点伤害"
	return card

# 创建紧急重构（法术卡）
func create_emergency_rebuild():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "紧急重构"
	card.card_type = card.CardType.SPELL
	card.cost = 2
	card.description = "选择一个被破坏的锻炉奇械怪兽，以守备表示特殊召唤"
	return card

# 创建完全过载（法术卡）
func create_full_overload():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "完全过载"
	card.card_type = card.CardType.SPELL
	card.cost = 5
	card.description = "支付1000生命值，破坏对方场上所有卡牌"
	return card