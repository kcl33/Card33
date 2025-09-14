extends Node2D

var game_controller = null
var battle_manager = null
var info_label = null
var card_effect_system = null

# 测试用的卡牌节点
var test_card_node = null

func _ready():
	print("加载测试战斗场景...")
	
	# 获取场景中的标签
	info_label = get_node("InfoLabel")
	info_label.text = "初始化游戏控制器..."
	
	# 初始化游戏控制器
	game_controller = preload("res://scripts/core/GameController.gd").new()
	battle_manager = preload("res://scripts/battle/BattleManager.gd").new()
	card_effect_system = preload("res://scripts/core/CardEffect.gd").new()
	
	# 设置战斗结果回调
	battle_manager.set_battle_result_callback(battle_result_handler)
	
	# 开始游戏
	game_controller.start_game()
	
	# 创建测试卡牌节点
	create_test_card()
	
	# 更新标签
	update_info_label()

func create_test_card():
	# 创建一个测试卡牌精灵
	test_card_node = Sprite2D.new()
	test_card_node.position = Vector2(400, 300)
	test_card_node.scale = Vector2(0.5, 0.5)
	
	# 创建一个简单的纹理
	var texture = ImageTexture.new()
	var image = Image.new()
	image.create(100, 150, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.8, 0.2, 0.5, 1))  # 洋红色
	texture.create_from_image(image)
	test_card_node.texture = texture
	
	add_child(test_card_node)

func simulate_turn():
	print("===================")
	print("模拟一回合操作:")
	
	# 模拟完整回合的所有阶段
	for phase in range(6):
		game_controller.process_phase()
	
	print("回合操作模拟完成")
	print("玩家1生命值: " + str(game_controller.player1.life_points))
	print("玩家2生命值: " + str(game_controller.player2.life_points))
	print("")
	
	# 更新标签
	update_info_label()

func simulate_battle():
	print("===================")
	print("模拟战斗:")
	
	# 创建一些测试怪兽
	var monster1 = preload("res://scripts/core/Card.gd").new()
	monster1.name = "测试怪兽1"
	monster1.card_type = monster1.CardType.MONSTER
	monster1.attack = 1500
	monster1.defense = 1200
	monster1.position = monster1.Position.ATTACK
	
	var monster2 = preload("res://scripts/core/Card.gd").new()
	monster2.name = "测试怪兽2"
	monster2.card_type = monster2.CardType.MONSTER
	monster2.attack = 1200
	monster2.defense = 800
	monster2.position = monster2.Position.ATTACK
	
	# 将怪兽放置到场上
	game_controller.player1.field.front_row[0] = monster1
	game_controller.player2.field.front_row[0] = monster2
	
	# 开始战斗
	battle_manager.start_battle_phase(game_controller.player1, game_controller.player2)
	battle_manager.select_attacker(monster1)
	battle_manager.select_target(monster2)
	
	# 更新标签
	update_info_label()

func test_summon_effect():
	if test_card_node != null:
		effect_manager.create_summon_effect(test_card_node)

func test_attack_effect():
	if test_card_node != null:
		# 创建一个目标节点
		var target_node = Sprite2D.new()
		target_node.position = Vector2(600, 300)
		var texture = ImageTexture.new()
		var image = Image.new()
		image.create(100, 150, false, Image.FORMAT_RGBA8)
		image.fill(Color(0.2, 0.2, 0.2, 1))  # 灰色
		texture.create_from_image(image)
		target_node.texture = texture
		add_child(target_node)
		
		effect_manager.create_attack_effect(test_card_node, target_node)
		
		# 3秒后删除目标节点
		await get_tree().create_timer(3.0).timeout
		if target_node != null:
			target_node.queue_free()

func test_destroy_effect():
	if test_card_node != null:
		effect_manager.create_destroy_effect(test_card_node)
		test_card_node = null  # 标记为已销毁

func test_card_effect():
	print("===================")
	print("测试卡牌效果:")
	
	# 创建测试效果
	var effects = card_effect_system.create_test_effects()
	
	# 应用效果
	for effect in effects:
		card_effect_system.apply_effect(effect, game_controller.player1, game_controller.player2)
	
	print("应用效果完成")
	print("玩家1生命值: " + str(game_controller.player1.life_points))
	print("玩家2生命值: " + str(game_controller.player2.life_points))
	print("玩家1费用点数: " + str(game_controller.player1.cost_points) + "/" + str(game_controller.player1.max_cost_points))
	
	# 更新标签
	update_info_label()

func battle_result_handler(result):
	print("战斗结果: ", result)
	match result.type:
		"direct_attack":
			print("直接攻击造成 ", result.damage, " 点伤害")
			if result.game_over:
				print("游戏结束!")
		"monster_battle":
			print("怪兽战斗: ", result.message)

func update_info_label():
	var text = "回合: " + str(game_controller.turn_count) + \
			" 玩家1 LP: " + str(game_controller.player1.life_points) + \
			" 玩家2 LP: " + str(game_controller.player2.life_points) + \
			"\n空格:下一回合 B:模拟战斗 E:测试卡牌效果"
	info_label.text = text

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		simulate_turn()
	elif Input.is_action_just_pressed("ui_cancel"):  # B键
		simulate_battle()
	elif Input.is_action_just_pressed("e"):  # E键
		test_card_effect()
