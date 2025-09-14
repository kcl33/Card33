# 步行机铠卡牌脚本示例
extends preload("res://scripts/core/cards/CardScript.gd")

func _init(card):
	.super(card)

# 当卡牌被召唤时触发效果
func on_summon():
	# 步行机铠被召唤时，抽一张卡
	if card.owner != null:
		card.owner.draw_card(1)
		print("步行机铠效果：抽1张卡")