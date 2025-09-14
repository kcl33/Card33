extends Node

# 召唤类型枚举
enum SummonType {
	NORMAL,      # 通常召唤
	TRIBUTE,     # 上级召唤
	SPECIAL,     # 特殊召唤
	EXTRA        # 额外召唤
}

# 召唤结果枚举
enum SummonResult {
	SUCCESS,           # 召唤成功
	NO_NORMAL_SUMMON,  # 没有通常召唤次数
	INSUFFICIENT_COST, # 费用不足
	INSUFFICIENT_EXTRA_COST, # 额外费用不足
	NO_SPACE,          # 没有空间
	INVALID_POSITION,  # 无效位置
	ZONE_OCCUPIED,     # 区域已被占用
	EXTRA_ZONE_CONDITION_NOT_MET # 额外区域使用条件未满足
}

# 召唤位置枚举
enum SummonPosition {
	FRONT_ROW,   # 前场
	BACK_ROW,    # 后场
	EXTRA_ZONE   # 额外区域
}

# 召唤方向枚举（表示形式）
enum Position {
	ATTACK,      # 攻击表示
	DEFENSE      # 守备表示
}

# 检查是否可以进行通常召唤
func can_normal_summon(player):
	# 检查玩家是否还有通常召唤次数
	return player.normal_summon_count > 0

# 检查是否可以进行上级召唤
func can_tribute_summon(player, card, position):
	# 检查费用是否足够
	if player.cost_points < card.cost:
		return [SummonResult.INSUFFICIENT_COST, "费用不足"]
	
	# 检查位置是否有效（上级召唤只能在前场）
	if position != SummonPosition.FRONT_ROW:
		return [SummonResult.INVALID_POSITION, "上级召唤只能在前场"]
	
	return [SummonResult.SUCCESS, "可以上级召唤"]

# 检查是否可以进行特殊召唤
func can_special_summon(player, card, position):
	# 检查费用是否足够
	if player.cost_points < card.cost:
		return [SummonResult.INSUFFICIENT_COST, "费用不足"]
	
	# 检查位置是否有效
	if position != SummonPosition.FRONT_ROW and position != SummonPosition.BACK_ROW:
		return [SummonResult.INVALID_POSITION, "特殊召唤只能在前场或后场"]
	
	return [SummonResult.SUCCESS, "可以特殊召唤"]

# 检查是否可以进行额外召唤
func can_extra_summon(player, card, position):
	# 检查额外费用是否足够
	if player.extra_points < card.extra_cost:
		return [SummonResult.INSUFFICIENT_EXTRA_COST, "额外费用不足"]
	
	# 检查是否是额外卡组的卡
	# 这里简化处理，假设所有调用这个方法的卡都是额外卡组的卡
	
	# 检查额外区域使用条件
	if position == SummonPosition.EXTRA_ZONE:
		if not check_extra_zone_condition(player):
			return [SummonResult.EXTRA_ZONE_CONDITION_NOT_MET, "额外区域使用条件未满足"]
	
	return [SummonResult.SUCCESS, "可以额外召唤"]

# 检查额外区域使用条件
# 必须在主要区域有一个从额外卡组特殊召唤的怪兽才能使用额外区域
func check_extra_zone_condition(player):
	# 检查前场和后场是否有从额外卡组特殊召唤的怪兽
	for i in range(5):
		if player.field.front_row[i] != null and player.field.front_row[i].summon_type == SummonType.EXTRA:
			return true
		if player.field.back_row[i] != null and player.field.back_row[i].summon_type == SummonType.EXTRA:
			return true
	return false

# 执行通常召唤
func perform_normal_summon(player, card, field_index, position_form=Position.ATTACK):
	# 检查是否还有通常召唤次数
	if not can_normal_summon(player):
		return [SummonResult.NO_NORMAL_SUMMON, "没有通常召唤次数"]
	
	# 检查费用
	if player.cost_points < card.cost:
		return [SummonResult.INSUFFICIENT_COST, "费用不足"]
	
	# 检查位置是否有效（通常召唤只能在前场）
	if position_form != Position.ATTACK:
		return [SummonResult.INVALID_POSITION, "通常召唤必须是攻击表示"]
	
	# 检查指定位置是否已被占用
	if player.field.front_row[field_index] != null:
		return [SummonResult.ZONE_OCCUPIED, "指定位置已被占用"]
	
	# 支付费用
	player.cost_points -= card.cost
	
	# 减少通常召唤次数
	player.normal_summon_count -= 1
	
	# 设置卡牌的召唤信息
	card.summon_type = SummonType.NORMAL
	card.position = Position.ATTACK
	
	# 放置到场上
	player.field.front_row[field_index] = card
	
	# 从手牌中移除
	player.hand.erase(card)
	
	return [SummonResult.SUCCESS, "通常召唤成功"]

# 执行上级召唤
func perform_tribute_summon(player, card, field_index, tribute_cards):
	var check_result = can_tribute_summon(player, card, SummonPosition.FRONT_ROW)
	if check_result[0] != SummonResult.SUCCESS:
		return check_result
	
	# 检查祭品数量是否足够
	# 这里简化处理，实际游戏中需要根据怪兽等级确定所需祭品数量
	
	# 检查指定位置是否已被占用
	if player.field.front_row[field_index] != null:
		return [SummonResult.ZONE_OCCUPIED, "指定位置已被占用"]
	
	# 支付费用
	player.cost_points -= card.cost
	
	# 移除祭品
	for tribute_card in tribute_cards:
		# 将祭品送去墓地
		player.graveyard.append(tribute_card)
		# 从场上移除
		player.remove_card_from_field(tribute_card)
	
	# 设置卡牌的召唤信息
	card.summon_type = SummonType.TRIBUTE
	card.position = Position.ATTACK
	
	# 放置到场上
	player.field.front_row[field_index] = card
	
	# 从手牌中移除
	player.hand.erase(card)
	
	return [SummonResult.SUCCESS, "上级召唤成功"]

# 执行特殊召唤
func perform_special_summon(player, card, field_row, field_index, position_form=Position.DEFENSE):
	var position = SummonPosition.FRONT_ROW if field_row == "front" else SummonPosition.BACK_ROW
	var check_result = can_special_summon(player, card, position)
	if check_result[0] != SummonResult.SUCCESS:
		return check_result
	
	# 检查指定位置是否已被占用
	var field_array = player.field.front_row if field_row == "front" else player.field.back_row
	if field_array[field_index] != null:
		return [SummonResult.ZONE_OCCUPIED, "指定位置已被占用"]
	
	# 支付费用
	if not player.pay_cost(card.cost):
		return [SummonResult.INSUFFICIENT_COST, "费用不足"]
	
	# 设置卡牌的召唤信息
	card.summon_type = SummonType.SPECIAL
	card.position = position_form
	
	# 放置到场上
	field_array[field_index] = card
	
	# 从手牌或其他地方移除（根据具体效果）
	if player.hand.has(card):
		player.hand.erase(card)
	
	return [SummonResult.SUCCESS, "特殊召唤成功"]

# 执行额外召唤
func perform_extra_summon(player, card, field_row, field_index, position_form=Position.ATTACK):
	var position = SummonPosition.EXTRA_ZONE
	if field_row != "extra":
		position = SummonPosition.FRONT_ROW if field_row == "front" else SummonPosition.BACK_ROW
	
	var check_result = can_extra_summon(player, card, position)
	if check_result[0] != SummonResult.SUCCESS:
		return check_result
	
	# 检查额外区域使用条件
	if position == SummonPosition.EXTRA_ZONE and not check_extra_zone_condition(player):
		return [SummonResult.EXTRA_ZONE_CONDITION_NOT_MET, "额外区域使用条件未满足"]
	
	# 检查指定位置是否已被占用
	var field_array
	match field_row:
		"front":
			field_array = player.field.front_row
		"back":
			field_array = player.field.back_row
		"extra":
			field_array = [player.field.extra_zone]  # 包装成数组以便统一处理
			field_index = 0
	
	if field_array[field_index] != null:
		return [SummonResult.ZONE_OCCUPIED, "指定位置已被占用"]
	
	# 支付额外费用
	if not player.pay_extra_cost(card.extra_cost):
		return [SummonResult.INSUFFICIENT_EXTRA_COST, "额外费用不足"]
	
	# 设置卡牌的召唤信息
	card.summon_type = SummonType.EXTRA
	card.position = position_form
	
	# 放置到场上
	if field_row == "extra":
		player.field.extra_zone = card
	else:
		field_array[field_index] = card
	
	# 从额外卡组中移除
	player.extra_deck.erase(card)
	
	return [SummonResult.SUCCESS, "额外召唤成功"]

# 从场上移除卡牌的辅助函数
func remove_card_from_field(player, card):
	player.remove_card_from_field(card)