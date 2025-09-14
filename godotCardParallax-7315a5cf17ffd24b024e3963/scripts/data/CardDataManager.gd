class_name CardDataManager
extends Node

var card_templates: Dictionary = {}

func _ready():
	load_card_templates()

func load_card_templates():
	# 这里应该从文件加载卡牌模板数据
	# 为了演示，我们创建一些示例卡牌
	
	# 示例单位卡
	card_templates["warrior"] = {
		"name": "战士",
		"type": "Unit",
		"cost": 2,
		"attack": 3,
		"defense": 2,
		"description": "基础的战士单位"
	}
	
	card_templates["mage"] = {
		"name": "法师",
		"type": "Unit",
		"cost": 3,
		"attack": 4,
		"defense": 1,
		"description": "高攻击力的魔法单位"
	}
	
	# 示例法术卡
	card_templates["fireball"] = {
		"name": "火球术",
		"type": "Spell",
		"cost": 2,
		"spell_type": "Instant",
		"description": "对目标造成3点伤害"
	}
	
	# 示例陷阱卡
	card_templates["shield"] = {
		"name": "护盾",
		"type": "Trap",
		"cost": 1,
		"trap_condition": "当对手攻击时",
		"description": "抵消一次攻击伤害"
	}
	
	# 示例政策卡
	card_templates["tax"] = {
		"name": "税收政策",
		"type": "Policy",
		"cost": 2,
		"policy_effect": "每回合额外获得1点费用",
		"description": "增加每回合的费用上限"
	}

func create_card_from_template(template_name: String) -> Card:
	if not card_templates.has(template_name):
		return null
	
	var template = card_templates[template_name]
	var card = Card.new()
	card.setup_card(template)
	return card

func get_all_templates() -> Array:
	return card_templates.keys()

func get_templates_by_type(card_type: String) -> Array:
	var templates = []
	for template_name in card_templates:
		var template = card_templates[template_name]
		if template.get("type", "") == card_type:
			templates.append(template_name)
	return templates