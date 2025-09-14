# 锻炉奇械主题卡牌示例
class_name ForgeCardExamples
extends Node

# 创建步行机铠（基础怪兽）
func create_walking_mech():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "步行机铠"
	card.card_type = card.CardType.MONSTER
	card.cost = 2
	card.attack = 800
	card.defense = 1200
	card.description = "基础的锻炉奇械单位，拥有不错的防御力"
	return card

# 创建蒸汽拳套（武器组件）
func create_steam_fist():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "蒸汽拳套"
	card.card_type = card.CardType.COMPONENT
	card.component_type = card.ComponentType.WEAPON
	card.cost = 1
	card.description = "增加攻击力的武器组件"
	return card

# 创建火箭滑轨（机动组件）
func create_rocket_treads():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "火箭滑轨"
	card.card_type = card.CardType.COMPONENT
	card.component_type = card.ComponentType.MOBILITY
	card.cost = 1
	card.description = "增加攻击力但降低防御力的机动组件"
	return card

# 创建蒸汽装甲（防御组件）
func create_steam_armor():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "蒸汽装甲"
	card.card_type = card.CardType.COMPONENT
	card.component_type = card.ComponentType.DEFENSE
	card.cost = 1
	card.description = "大幅提升防御力的装甲组件"
	return card

# 创建核心熔炉驱动（高级怪兽）
func create_core_furnace_drive():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "核心熔炉驱动"
	card.card_type = card.CardType.MONSTER
	card.cost = 4
	card.attack = 1800
	card.defense = 1000
	card.description = "高级的锻炉奇械单位，拥有强大的攻击力"
	return card

# 创建过载蒸汽喷射（法术）
func create_overload_steam_jet():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "过载蒸汽喷射"
	card.card_type = card.CardType.SPELL
	card.cost = 1
	card.description = "造成500点伤害的法术卡"
	return card

# 创建紧急重构（法术）
func create_emergency_rebuild():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "紧急重构"
	card.card_type = card.CardType.SPELL
	card.cost = 2
	card.description = "恢复800点生命值"
	return card

# 创建全功率过载（法术）
func create_full_overload():
	var card = preload("res://scripts/core/Card.gd").new()
	card.card_name = "全功率过载"
	card.card_type = card.CardType.SPELL
	card.cost = 3
	card.description = "抽2张卡并获得1点护甲"
	return card