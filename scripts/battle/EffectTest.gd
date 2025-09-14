extends Node2D

# 测试用的卡牌节点
var test_card_node = null
var test_target_node = null

func _ready():
	print("加载效果测试场景...")
	
	# 创建测试卡牌节点
	create_test_card()
	create_test_target()
	
	# 更新标签
	update_info_label()
	
	print("效果测试场景加载完成")

func create_test_card():
	# 创建一个测试卡牌精灵
	test_card_node = Sprite2D.new()
	test_card_node.position = Vector2(200, 300)
	test_card_node.scale = Vector2(0.5, 0.5)
	
	# 创建一个简单的纹理
	var texture = ImageTexture.new()
	var image = Image.new()
	image.create(100, 150, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.8, 0.2, 0.5, 1))  # 洋红色
	texture.create_from_image(image)
	test_card_node.texture = texture
	
	add_child(test_card_node)

func create_test_target():
	# 创建一个测试目标精灵
	test_target_node = Sprite2D.new()
	test_target_node.position = Vector2(600, 300)
	test_target_node.scale = Vector2(0.5, 0.5)
	
	# 创建一个简单的纹理
	var texture = ImageTexture.new()
	var image = Image.new()
	image.create(100, 150, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.2, 0.2, 0.2, 1))  # 灰色
	texture.create_from_image(image)
	test_target_node.texture = texture
	
	add_child(test_target_node)

func test_summon_effect():
	if test_card_node != null:
		print("测试召唤效果")
		create_summon_effect(test_card_node)

func test_attack_effect():
	if test_card_node != null and test_target_node != null:
		print("测试攻击效果")
		create_attack_effect(test_card_node, test_target_node)

func test_destroy_effect():
	if test_card_node != null:
		print("测试破坏效果")
		create_destroy_effect(test_card_node)
		test_card_node = null  # 标记为已销毁

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

func update_info_label():
	print("=== 效果测试场景 ===")
	print("1: 召唤效果")
	print("2: 攻击效果") 
	print("3: 破坏效果")
	print("ESC: 返回主菜单")

func _process(_delta):
	if Input.is_action_just_pressed("1"):
		test_summon_effect()
	elif Input.is_action_just_pressed("2"):
		test_attack_effect()
	elif Input.is_action_just_pressed("3"):
		test_destroy_effect()
	elif Input.is_action_just_pressed("ui_cancel"):  # ESC键
		print("返回主菜单")
		get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
