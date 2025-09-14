extends Node

# 效果类型枚举
enum EffectType {
	SUMMON,        # 召唤效果
	ATTACK,        # 攻击效果
	DESTROY,       # 破坏效果
	DIRECT_DAMAGE, # 直接伤害效果
	HEAL,          # 治疗效果
	BUFF,          # 增益效果
	DEBUFF         # 减益效果
}

# 引用Tween动画插件
var tween_orchestrator = null

func _init():
	# 初始化Tween动画插件（如果存在）
	# if has_node("/root/TweenOrchestrator"):
	# 	tween_orchestrator = get_node("/root/TweenOrchestrator")
	pass

# 创建召唤效果
func create_summon_effect(card_node):
	var tween = get_tree().create_tween()
	
	# 缩放效果
	card_node.scale = Vector2(0.1, 0.1)
	tween.tween_property(card_node, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	# 闪烁效果
	tween.parallel().tween_property(card_node, "modulate", Color(1, 0.5, 1, 1), 0.2)
	tween.tween_property(card_node, "modulate", Color(1, 1, 1, 1), 0.2)
	
	return tween

# 创建攻击效果
func create_attack_effect(attacker_node, target_node):
	var tween = get_tree().create_tween()
	
	# 攻击者冲向目标
	var original_position = attacker_node.position
	var target_position = target_node.position
	var midpoint = (original_position + target_position) / 2
	
	# 移动到中点
	tween.tween_property(attacker_node, "position", midpoint, 0.1).set_trans(Tween.TRANS_LINEAR)
	
	# 移动回原位
	tween.tween_property(attacker_node, "position", original_position, 0.1).set_trans(Tween.TRANS_LINEAR)
	
	# 目标闪烁表示受到攻击
	tween.parallel().tween_property(target_node, "modulate", Color(1, 0, 0, 1), 0.1)
	tween.tween_property(target_node, "modulate", Color(1, 1, 1, 1), 0.1)
	
	return tween

# 创建破坏效果
func create_destroy_effect(card_node):
	var tween = get_tree().create_tween()
	
	# 震动效果
	var original_position = card_node.position
	tween.tween_property(card_node, "position", original_position + Vector2(5, 0), 0.05)
	tween.tween_property(card_node, "position", original_position + Vector2(-5, 0), 0.05)
	tween.tween_property(card_node, "position", original_position + Vector2(0, 5), 0.05)
	tween.tween_property(card_node, "position", original_position + Vector2(0, -5), 0.05)
	tween.tween_property(card_node, "position", original_position, 0.05)
	
	# 缩小并淡出
	tween.parallel().tween_property(card_node, "scale", Vector2(0, 0), 0.3).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_property(card_node, "modulate", Color(1, 1, 1, 0), 0.3)
	
	# 完成后从场景中移除
	tween.tween_callback(card_node.queue_free)
	
	return tween

# 创建直接伤害效果
func create_direct_damage_effect(player_node, damage):
	var tween = get_tree().create_tween()
	
	# 屏幕震动效果
	var camera = get_viewport().get_camera_2d()
	if camera != null:
		var original_position = camera.position
		tween.tween_property(camera, "position", original_position + Vector2(5, 0), 0.05)
		tween.tween_property(camera, "position", original_position + Vector2(-5, 0), 0.05)
		tween.tween_property(camera, "position", original_position, 0.05)
	
	# 玩家节点闪烁
	if player_node != null:
		tween.parallel().tween_property(player_node, "modulate", Color(1, 0, 0, 1), 0.1)
		tween.tween_property(player_node, "modulate", Color(1, 1, 1, 1), 0.1)
	
	return tween

# 创建治疗效果
func create_heal_effect(player_node, heal_amount):
	var tween = get_tree().create_tween()
	
	# 玩家节点绿色闪烁
	if player_node != null:
		tween.tween_property(player_node, "modulate", Color(0, 1, 0, 1), 0.2)
		tween.tween_property(player_node, "modulate", Color(1, 1, 1, 1), 0.2)
	
	return tween

# 创建增益效果
func create_buff_effect(card_node):
	var tween = get_tree().create_tween()
	
	# 添加光环效果
	if card_node != null:
		tween.tween_property(card_node, "modulate", Color(0.5, 0.5, 1, 1), 0.3)
		tween.tween_property(card_node, "modulate", Color(1, 1, 1, 1), 0.3)
	
	return tween

# 创建减益效果
func create_debuff_effect(card_node):
	var tween = get_tree().create_tween()
	
	# 添加暗淡效果
	if card_node != null:
		tween.tween_property(card_node, "modulate", Color(0.5, 0.5, 0.5, 1), 0.3)
		tween.tween_property(card_node, "modulate", Color(1, 1, 1, 1), 0.3)
	
	return tween

# 创建卡牌悬停效果
func create_hover_effect(card_node):
	var tween = get_tree().create_tween()
	
	# 提升一点Y位置并轻微旋转
	tween.tween_property(card_node, "position:y", card_node.position.y - 10, 0.2)
	tween.parallel().tween_property(card_node, "rotation", 0.05, 0.2)
	
	return tween

# 创建卡牌取消悬停效果
func create_unhover_effect(card_node):
	var tween = get_tree().create_tween()
	
	# 回到原始位置和旋转
	tween.tween_property(card_node, "position:y", card_node.position.y + 10, 0.2)
	tween.parallel().tween_property(card_node, "rotation", 0, 0.2)
	
	return tween