extends Node

# 创建锻炉奇械主题的示例卡牌

# 创建步行机铠（基础单位）
func create_walking_mech():
	var card = Card.new()
	card.card_name = "步行机铠"
	card.card_type = card.CardType.MONSTER
	card.cost = 2
	card.attack = 1000
	card.defense = 1500
	card.description = "它是所有伟大造物的基石。"
	# 标记为可组装单位
	return card

# 创建蒸汽拳套（武器组件）
func create_steam_fist():
	var card = Card.new()
	card.card_name = "蒸汽拳套"
	card.card_type = card.CardType.COMPONENT
	card.component_type = card.ComponentType.WEAPON
	card.cost = 1
	card.description = "一拳不行，那就再来一拳。"
	return card

# 创建火箭履带（移动组件）
func create_rocket_treads():
	var card = Card.new()
	card.card_name = "火箭履带"
	card.card_type = card.CardType.COMPONENT
	card.component_type = card.ComponentType.MOBILITY
	card.cost = 1
	card.description = "慢点，伙计！我里面的螺丝要松了！"
	return card

# 创建核心熔炉驱动机
func create_core_furnace_drive():
	var card = Card.new()
	card.card_name = "核心熔炉驱动"
	card.card_type = card.CardType.MONSTER
	card.cost = 5
	card.attack = 2000
	card.defense = 3000
	card.description = "它是心跳，是动力，是整个城市的生命之源。"
	return card

# 创建过载蒸汽喷射（法术）
func create_overload_steam_jet():
	var card = Card.new()
	card.card_name = "过载·蒸汽喷射"
	card.card_type = card.CardType.SPELL
	card.spell_type = card.SpellType.INSTANT
	card.cost = 3
	card.overload_cost = 2
	card.description = "小心压力阀！"
	return card

# 创建紧急再造（法术）
func create_emergency_rebuild():
	var card = Card.new()
	card.card_name = "紧急重构"
	card.card_type = card.CardType.SPELL
	card.spell_type = card.SpellType.INSTANT
	card.cost = 2
	card.overload_cost = 1  # 弃一张手牌
	card.description = "扳手和焊枪能解决百分之九十九的问题。"
	return card

# 创建全面过载（法术）
func create_full_overload():
	var card = Card.new()
	card.card_name = "全功率过载"
	card.card_type = card.CardType.SPELL
	card.spell_type = card.SpellType.INSTANT
	card.cost = 4
	card.overload_cost = 1  # 下回合牺牲一个机械单位
	card.description = "把功率推到百分之一百一十！等等，计量表要爆了！"
	return card