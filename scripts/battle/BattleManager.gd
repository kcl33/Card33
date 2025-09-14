extends Node

# 引用其他系统
var battle_system = preload("res://scripts/core/BattleSystem.gd").new()
var summon_system = preload("res://scripts/core/SummonSystem.gd").new()

# 战斗阶段枚举
enum BattlePhase {
	START,           # 战斗开始
	SELECT_ATTACKER, # 选择攻击怪兽
	SELECT_TARGET,   # 选择目标
	RESOLVE_BATTLE,  # 解决战斗
	END              # 战斗结束
}

# 战斗状态
var current_phase = BattlePhase.START
var attacker = null
var target = null
var attacker_player = null
var target_player = null

# 战斗结果回调
var battle_result_callback = null

func _init():
	pass

# 开始战斗阶段
func start_battle_phase(attacking_player, defending_player):
	attacker_player = attacking_player
	target_player = defending_player
	current_phase = BattlePhase.SELECT_ATTACKER
	print("进入战斗阶段，请选择攻击怪兽")

# 选择攻击怪兽
func select_attacker(card):
	if current_phase != BattlePhase.SELECT_ATTACKER:
		return false
	
	if card.card_type != card.CardType.MONSTER:
		print("只能选择怪兽卡进行攻击")
		return false
	
	if card.position != card.Position.ATTACK:
		print("只能选择攻击表示的怪兽进行攻击")
		return false
	
	# 检查怪兽是否已经攻击过
	# 这里简化处理，实际游戏中需要标记已攻击的怪兽
	
	attacker = card
	current_phase = BattlePhase.SELECT_TARGET
	print("已选择攻击怪兽: ", card.name, "，请选择目标")
	return true

# 选择目标
func select_target(target_card):
	if current_phase != BattlePhase.SELECT_TARGET:
		return false
	
	# 如果目标为空，表示直接攻击玩家
	if target_card == null:
		# 检查是否可以进行直接攻击
		if not battle_system.can_direct_attack(target_player):
			print("对方场上有怪兽，无法直接攻击玩家")
			return false
		
		target = null # 直接攻击玩家
		current_phase = BattlePhase.RESOLVE_BATTLE
		print("选择直接攻击玩家")
		resolve_battle()
		return true
	else:
		# 攻击对方怪兽
		if target_card.card_type != target_card.CardType.MONSTER:
			print("只能选择怪兽作为攻击目标")
			return false
		
		target = target_card
		current_phase = BattlePhase.RESOLVE_BATTLE
		print("选择攻击目标: ", target_card.name)
		resolve_battle()
		return true

# 解决战斗
func resolve_battle():
	if current_phase != BattlePhase.RESOLVE_BATTLE:
		return
	
	print("解决战斗...")
	
	var result
	if target == null:
		# 直接攻击玩家
		var game_over = battle_system.direct_attack(attacker_player, target_player, attacker, attacker.position)
		result = {
			"type": "direct_attack",
			"attacker": attacker,
			"damage": battle_system.get_battle_power(attacker, attacker.position),
			"game_over": game_over
		}
		
		print("直接攻击玩家，造成 ", result.damage, " 点伤害")
		if game_over:
			print("游戏结束！玩家 ", "2" if target_player == attacker_player else "1", " 获胜！")
	else:
		# 怪兽间战斗
		var battle_result = battle_system.battle_monsters(
			attacker_player, target_player, attacker, target, 
			attacker.position, target.position)
		
		result = {
			"type": "monster_battle",
			"attacker": attacker,
			"target": target,
			"result": battle_result[0],
			"message": battle_result[1]
		}
		
		match battle_result[0]:
			battle_system.BattleResult.WIN:
				print(attacker.name, " 击败了 ", target.name)
			battle_system.BattleResult.LOSE:
				print(target.name, " 击败了 ", attacker.name)
			battle_system.BattleResult.DRAW:
				print(attacker.name, " 和 ", target.name, " 同归于尽")
	
	current_phase = BattlePhase.END
	
	# 调用回调函数
	if battle_result_callback != null:
		battle_result_callback.call(result)
	
	# 重置战斗状态
	reset_battle_state()

# 重置战斗状态
func reset_battle_state():
	current_phase = BattlePhase.START
	attacker = null
	target = null
	attacker_player = null
	target_player = null
	battle_result_callback = null

# 设置战斗结果回调
func set_battle_result_callback(callback):
	battle_result_callback = callback