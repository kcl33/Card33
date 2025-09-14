# 卡牌脚本基类 - 允许每张卡牌定义自己的效果
extends Node

var card = null

func _init(card_data):
	card = card_data

# 当卡牌被抽到时调用
func on_draw():
	pass

# 当卡牌被打出时调用
func on_play(target=null):
	pass

# 当卡牌被召唤时调用（仅适用于怪兽卡）
func on_summon():
	pass

# 当回合开始时调用
func on_turn_start():
	pass

# 当回合结束时调用
func on_turn_end():
	pass

# 当卡牌被破坏时调用
func on_destroy():
	pass

# 当卡牌攻击时调用
func on_attack(target=null):
	pass

# 当卡牌受到攻击时调用
func on_attacked(attacker=null):
	pass