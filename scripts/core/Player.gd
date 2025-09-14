extends Node

# 玩家状态枚举
enum PlayerState {
	NORMAL,      # 正常状态
	LOST,        # 失败状态
	WON          # 胜利状态
}

# 玩家基本信息
var player_id = 0
var life_points = 8000
var cost_points = 1  # 当前费用点数
var max_cost_points = 3  # 最大费用点数
var extra_points = 2  # 额外点数
var armor_points = 0  # 护甲值

# 玩家卡牌集合
var deck = []        # 牌组
var hand = []        # 手牌
var graveyard = []   # 墓地
var banished = []    # 除外区
var field = null     # 场上区域
var extra_deck = []  # 额外卡组

# 玩家状态
var state = PlayerState.NORMAL

# 召唤信息
var normal_summon_count = 1  # 每回合通常召唤次数

# 遗物系统
var relic_manager = null

func _init(id):
	player_id = id
	field = preload("res://scripts/core/Field.gd").new()
	relic_manager = preload("res://scripts/core/RelicManager.gd").new()

# 抽卡
func draw_card(count=1):
	for i in range(count):
		if deck.size() > 0:
			var card = deck.pop_front()
			hand.append(card)
			card.set_owner(self)  # 设置卡牌所有者
			print("玩家", player_id, "抽到了: ", card.card_name)
			
			# 触发抽卡效果
			card.trigger_effect("on_draw")
			
			# 触发遗物效果：抽卡时
			relic_manager.trigger_relics_by_timing(self, relic_manager.Relic.TriggerTiming.CARD_DRAWN, card)
		else:
			# 牌组没牌时，玩家输掉游戏
			state = PlayerState.LOST
			print("玩家", player_id, "的牌组空了，游戏结束！")
			return false
	return true

# 打出卡牌
func play_card(card, position=null):
	if not hand.has(card):
		print("手牌中没有这张卡")
		return false
	
	if card.cost > cost_points:
		print("费用不足，无法打出这张卡")
		return false
	
	# 支付费用
	cost_points -= card.cost
	
	# 从手牌移除
	hand.erase(card)
	
	# 根据卡牌类型处理
	match card.card_type:
		card.CardType.MONSTER:
			# 怪兽卡需要放置到场上
			if field.place_monster(card, position):
				print("玩家", player_id, "召唤了: ", card.card_name)
				# 触发召唤效果
				card.trigger_effect("on_summon")
				# 触发遗物效果：召唤怪兽时
				relic_manager.trigger_relics_by_timing(self, relic_manager.Relic.TriggerTiming.MONSTER_SUMMONED, card)
				return true
			else:
				# 召唤失败，卡牌回到手牌
				hand.append(card)
				cost_points += card.cost
				return false
				
		card.CardType.SPELL:
			# 法术卡立即生效
			activate_spell(card)
			graveyard.append(card)
			print("玩家", player_id, "使用了法术: ", card.card_name)
			# 触发打出效果
			card.trigger_effect("on_play")
			# 触发遗物效果：打出卡牌时
			relic_manager.trigger_relics_by_timing(self, relic_manager.Relic.TriggerTiming.CARD_PLAYED, card)
			return true
			
		card.CardType.POLICY:
			# 政策卡立即生效
			activate_policy(card)
			graveyard.append(card)
			print("玩家", player_id, "使用了政策: ", card.card_name)
			# 触发打出效果
			card.trigger_effect("on_play")
			# 触发遗物效果：打出卡牌时
			relic_manager.trigger_relics_by_timing(self, relic_manager.Relic.TriggerTiming.CARD_PLAYED, card)
			return true
			
		card.CardType.COMPONENT:
			# 组件卡需要选择目标单位
			print("玩家", player_id, "打出了组件: ", card.card_name, "，请选择目标单位")
			return "select_target"  # 需要选择目标
	
	return false

# 激活法术卡
func activate_spell(spell_card):
	# 这里应该根据具体法术效果处理
	# 简化处理，只打印信息
	print("激活法术效果: ", spell_card.card_name)

# 激活政策卡
func activate_policy(policy_card):
	# 这里应该根据具体政策效果处理
	# 简化处理，只打印信息
	print("激活政策效果: ", policy_card.card_name)

# 安装组件到单位
func attach_component(component, target_unit):
	if not hand.has(component):
		print("手牌中没有这个组件")
		return false
	
	if component.card_type != component.CardType.COMPONENT:
		print("不是组件卡")
		return false
	
	if not target_unit.can_attach_component(component):
		print("无法安装该组件")
		return false
	
	# 从手牌移除组件
	hand.erase(component)
	
	# 安装到目标单位
	target_unit.add_component(component)
	
	print("将组件 ", component.card_name, " 安装到 ", target_unit.card_name)
	
	# 触发组件安装效果
	trigger_assemble_effect(target_unit, component)
	
	return true

# 触发组装效果
func trigger_assemble_effect(unit, component):
	# 这里应该根据具体组件效果处理
	# 简化处理，只打印信息
	print("触发组装效果: ", component.card_name, " 安装到 ", unit.card_name)
	
	# 根据组件类型应用效果
	match component.component_type:
		component.ComponentType.WEAPON:
			unit.attack += 500
			print("单位攻击力增加500")
		component.ComponentType.MOBILITY:
			unit.attack += 100
			unit.defense -= 100
			print("单位获得+100/-100属性变化")

# 发动超载效果
func activate_overload(card, overload_cost_paid=true):
	if not overload_cost_paid:
		print("未支付超载费用")
		return false
	
	# 这里应该根据具体超载效果处理
	# 简化处理，只打印信息
	print("发动超载效果: ", card.card_name)
	return true

# 支付费用
func pay_cost(cost):
	if cost_points >= cost:
		cost_points -= cost
		return true
	return false

# 支付额外费用
func pay_extra_cost(extra_cost):
	if extra_points >= extra_cost:
		extra_points -= extra_cost
		return true
	return false

# 回合开始时调用
func on_turn_start():
	# 触发遗物效果：回合开始时
	relic_manager.trigger_relics_by_timing(self, relic_manager.Relic.TriggerTiming.TURN_START)

# 回合结束时调用
func on_turn_end():
	# 触发遗物效果：回合结束时
	relic_manager.trigger_relics_by_timing(self, relic_manager.Relic.TriggerTiming.TURN_END)

# 战斗开始时调用
func on_battle_start():
	# 触发遗物效果：战斗开始时
	relic_manager.trigger_relics_by_timing(self, relic_manager.Relic.TriggerTiming.BATTLE_START)

# 战斗结束时调用
func on_battle_end():
	# 触发遗物效果：战斗结束时
	relic_manager.trigger_relics_by_timing(self, relic_manager.Relic.TriggerTiming.BATTLE_END)

# 抽卡时调用
func on_card_drawn(card):
	# 触发遗物效果：抽卡时
	relic_manager.trigger_relics_by_timing(self, relic_manager.Relic.TriggerTiming.CARD_DRAWN, card)

# 受到伤害时调用
func on_damage_taken(damage):
	# 触发遗物效果：受到伤害时
	relic_manager.trigger_relics_by_timing(self, relic_manager.Relic.TriggerTiming.DAMAGE_TAKEN, damage)

# 造成伤害时调用
func on_damage_dealt(damage):
	# 触发遗物效果：造成伤害时
	relic_manager.trigger_relics_by_timing(self, relic_manager.Relic.TriggerTiming.DAMAGE_DEALT, damage)

# 从场上移除卡牌的辅助函数
func remove_card_from_field(card):
	# 在前场查找
	for i in range(field.front_row.size()):
		if field.front_row[i] == card:
			field.front_row[i] = null
			return
	
	# 在后场查找
	for i in range(field.back_row.size()):
		if field.back_row[i] == card:
			field.back_row[i] = null
			return
	
	# 在额外区域查找
	if field.extra_zone == card:
		field.extra_zone = null