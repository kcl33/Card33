class_name CardDisplay
extends Control

@onready var card_background = $CardBackground
@onready var card_frame = $CardFrame

var card: Card

func _ready():
	update_display()

func set_card(c: Card):
	card = c
	update_display()

func update_display():
	if not card:
		return
	
	# 根据卡牌类型设置颜色
	match card.card_type:
		"Unit":
			card_background.color = Color(0.8, 0.8, 1.0, 1.0)  # 蓝色调表示单位卡
		"Spell":
			card_background.color = Color(0.8, 1.0, 0.8, 1.0)  # 绿色调表示法术卡
		"Trap":
			card_background.color = Color(1.0, 0.8, 0.8, 1.0)  # 红色调表示陷阱卡
		"Policy":
			card_background.color = Color(1.0, 1.0, 0.8, 1.0)  # 黄色调表示政策卡
		_:
			card_background.color = Color(0.5, 0.5, 0.5, 1.0)  # 默认灰色

func highlight():
	# 高亮显示卡牌（用于表示可交互）
	card_frame.modulate = Color(1.0, 1.0, 0.0, 1.0)  # 黄色高亮

func unhighlight():
	# 取消高亮
	card_frame.modulate = Color(1.0, 1.0, 1.0, 1.0)