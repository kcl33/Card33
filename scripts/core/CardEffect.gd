extends Node

# 卡牌效果类型枚举
enum EffectType {
	DRAW_CARD,          # 抽卡效果
	DESTROY_MONSTER,    # 破坏怪兽
	INCREASE_ATTACK,    # 增加攻击力
	DECREASE_ATTACK,    # 减少攻击力
	HEAL_LP,            # 回复生命值
	DAMAGE_LP,          # 造成伤害
	INCREASE_COST,      # 增加费用
	DECREASE_COST,      # 减少费用
	INCREASE_COST_LIMIT # 增加费用上限
}

# 卡牌效果数据结构
class CardEffectData:
	var effect_type
	var value
	var target  # "self", "opponent", "all"
	
	func _init(type, val, tgt="opponent"):
		effect_type = type
		value = val
		target = tgt

# 应用卡牌效果到目标玩家
func apply_effect(effect_data, source_player, target_player):
	match effect_data.effect_type:
		EffectType.DRAW_CARD:
			if effect_data.target == "self":
				source_player.draw_card(effect_data.value)
			elif effect_data.target == "opponent":
				target_player.draw_card(effect_data.value)
				
		EffectType.DESTROY_MONSTER:
			# 简化实现，实际应指定具体怪兽
			destroy_random_monster(target_player)
			
		EffectType.INCREASE_ATTACK:
			# 增加攻击力效果（需要指定怪兽）
			pass
			
		EffectType.DECREASE_ATTACK:
			# 减少攻击力效果（需要指定怪兽）
			pass
			
		EffectType.HEAL_LP:
			if effect_data.target == "self":
				source_player.life_points = min(source_player.life_points + effect_data.value, 8000)
			elif effect_data.target == "opponent":
				target_player.life_points = min(target_player.life_points + effect_data.value, 8000)
				
		EffectType.DAMAGE_LP:
			if effect_data.target == "self":
				source_player.life_points = max(source_player.life_points - effect_data.value, 0)
			elif effect_data.target == "opponent":
				target_player.life_points = max(target_player.life_points - effect_data.value, 0)
				
		EffectType.INCREASE_COST:
			if effect_data.target == "self":
				source_player.cost_points = min(source_player.cost_points + effect_data.value, source_player.max_cost_points)
			elif effect_data.target == "opponent":
				target_player.cost_points = min(target_player.cost_points + effect_data.value, target_player.max_cost_points)
				
		EffectType.DECREASE_COST:
			if effect_data.target == "self":
				source_player.cost_points = max(source_player.cost_points - effect_data.value, 0)
			elif effect_data.target == "opponent":
				target_player.cost_points = max(target_player.cost_points - effect_data.value, 0)
				
		EffectType.INCREASE_COST_LIMIT:
			if effect_data.target == "self":
				source_player.max_cost_points = min(source_player.max_cost_points + effect_data.value, 12)
			elif effect_data.target == "opponent":
				target_player.max_cost_points = min(target_player.max_cost_points + effect_data.value, 12)

# 破坏目标玩家场上随机一只怪兽
func destroy_random_monster(player):
	var monsters = []
	
	# 收集前场怪兽
	for i in range(player.field.front_row.size()):
		if player.field.front_row[i] != null:
			monsters.append([player.field.front_row[i], "front", i])
	
	# 收集后场怪兽
	for i in range(player.field.back_row.size()):
		if player.field.back_row[i] != null:
			monsters.append([player.field.back_row[i], "back", i])
	
	# 如果有怪兽，随机破坏一只
	if monsters.size() > 0:
		var random_index = randi() % monsters.size()
		var monster_data = monsters[random_index]
		var monster = monster_data[0]
		var row = monster_data[1]
		var index = monster_data[2]
		
		# 送去墓地
		player.graveyard.append(monster)
		
		# 从场上移除
		if row == "front":
			player.field.front_row[index] = null
		else:
			player.field.back_row[index] = null
		
		print("破坏了 ", monster.name)

# 创建测试卡牌效果
func create_test_effects():
	var effects = []
	
	# 抽2张卡
	effects.append(CardEffectData.new(EffectType.DRAW_CARD, 2, "self"))
	
	# 对对手造成500点伤害
	effects.append(CardEffectData.new(EffectType.DAMAGE_LP, 500, "opponent"))
	
	# 回复自己1000点生命值
	effects.append(CardEffectData.new(EffectType.HEAL_LP, 1000, "self"))
	
	# 增加自己1点费用
	effects.append(CardEffectData.new(EffectType.INCREASE_COST, 1, "self"))
	
	# 增加自己费用上限1点
	effects.append(CardEffectData.new(EffectType.INCREASE_COST_LIMIT, 1, "self"))
	
	return effects