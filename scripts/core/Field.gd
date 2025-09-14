extends Node

# 场上区域定义
# 前场：怪兽区域（5个）
# 后场：魔法陷阱区域（5个）
# 额外区域（1个）
var front_row = []
var back_row = []
var extra_zone = null  # 额外区域

func _init():
	# 初始化场上区域
	for i in range(5):
		front_row.append(null)
		back_row.append(null)
	
	# 初始化额外区域
	extra_zone = null

# 放置怪兽
func place_monster(monster_card, position=null):
	# 寻找空位放置怪兽
	for i in range(front_row.size()):
		if front_row[i] == null:
			front_row[i] = monster_card
			monster_card.position = position if position != null else monster_card.Position.ATTACK
			return true
	print("前场已满，无法放置怪兽")
	return false

# 放置魔法/陷阱卡
func place_spell(spell_card):
	# 寻找空位放置魔法/陷阱卡
	for i in range(back_row.size()):
		if back_row[i] == null:
			back_row[i] = spell_card
			return true
	print("后场已满，无法放置魔法/陷阱卡")
	return false

# 放置到额外区域
func place_in_extra_zone(card):
	if extra_zone == null:
		extra_zone = card
		return true
	else:
		print("额外区域已被占用")
		return false

# 移除怪兽
func remove_monster(monster_card):
	for i in range(front_row.size()):
		if front_row[i] == monster_card:
			front_row[i] = null
			return true
	return false

# 移除魔法/陷阱卡
func remove_spell(spell_card):
	for i in range(back_row.size()):
		if back_row[i] == spell_card:
			back_row[i] = null
			return true
	return false

# 移除额外区域的卡
func remove_from_extra_zone(card):
	if extra_zone == card:
		extra_zone = null
		return true
	return false