extends Node

# 战斗结果枚举
enum BattleResult {
	WIN,           # 攻击方获胜
	LOSE,          # 防守方获胜
	DRAW,          # 平局
	DESTROY_BOTH   # 两者都被破坏
}

# 战斗类型枚举
enum BattleType {
	ATTACK_MONSTER,  # 攻击怪兽
	ATTACK_DIRECT    # 直接攻击玩家
}

# 执行怪兽之间的战斗
func battle_monsters(attacking_player, defending_player, attacking_card, defending_card, attack_position, defend_position):
	# 计算攻击力和守备力
	var attack_power = get_battle_power(attacking_card, attack_position)
	var defend_power = get_battle_power(defending_card, defend_position)
	
	# 判断战斗结果
	if attack_power > defend_power:
		# 攻击方获胜
		# 防守方怪兽被破坏送去墓地
		send_to_graveyard(defending_player, defending_card)
		return [BattleResult.WIN, "攻击方获胜"]
	elif attack_power < defend_power:
		# 防守方获胜
		# 攻击方怪兽被破坏送去墓地
		send_to_graveyard(attacking_player, attacking_card)
		return [BattleResult.LOSE, "防守方获胜"]
	else:
		# 平局，两者都送去墓地
		send_to_graveyard(attacking_player, attacking_card)
		send_to_graveyard(defending_player, defending_card)
		return [BattleResult.DRAW, "平局"]

# 直接攻击玩家
func direct_attack(_attacking_player, defending_player, attacking_card, attack_position):
	# 计算攻击力
	var attack_power = get_battle_power(attacking_card, attack_position)
	
	# 减少防守方玩家的基本分
	defending_player.life_points -= attack_power
	
	# 检查游戏是否结束
	return defending_player.life_points <= 0

# 获取怪兽在特定表示形式下的战斗力量
func get_battle_power(card, position):
	if card.card_type != card.CardType.MONSTER:
		return 0
	
	match position:
		card.Position.ATTACK:
			return card.attack
		card.Position.DEFENSE:
			return card.defense
		_:
			return 0

# 将卡牌送去墓地
func send_to_graveyard(player, card):
	# 从场上移除卡牌
	remove_card_from_field(player, card)
	
	# 将卡牌加入墓地
	player.graveyard.append(card)

# 从场上移除卡牌的辅助函数
func remove_card_from_field(player, card):
	# 在前场查找
	for i in range(player.field.front_row.size()):
		if player.field.front_row[i] == card:
			player.field.front_row[i] = null
			return
	
	# 在后场查找
	for i in range(player.field.back_row.size()):
		if player.field.back_row[i] == card:
			player.field.back_row[i] = null
			return
	
	# 在额外区域查找
	if player.field.extra_zone == card:
		player.field.extra_zone = null

# 检查是否可以进行直接攻击
func can_direct_attack(defending_player):
	# 如果防守方前场有怪兽，则不能直接攻击
	for monster in defending_player.field.front_row:
		if monster != null:
			return false
	return true
