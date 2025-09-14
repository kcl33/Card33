# 基于专业Card Framework插件的战斗控制器
extends Node2D

@onready var card_manager = $CardManager
@onready var json_factory = $CardManager/CardFactory

var player1_hand
var player2_hand
var player1_field
var player2_field

func _ready():
	# 初始化游戏
	initialize_game()

func initialize_game():
	# 设置JSON卡片工厂
	json_factory.card_info_dir = "res://cards"
	json_factory.card_asset_dir = "res://assets/cards"
	
	# 创建手牌容器
	player1_hand = preload("res://addons/card-framework/hand.tscn").instantiate()
	player1_hand.name = "Player1Hand"
	player1_hand.position = Vector2(0, 600)
	player1_hand.card_face_up = true
	add_child(player1_hand)
	
	player2_hand = preload("res://addons/card-framework/hand.tscn").instantiate()
	player2_hand.name = "Player2Hand"
	player2_hand.position = Vector2(0, 0)
	player2_hand.card_face_up = false
	add_child(player2_hand)
	
	# 创建场上区域
	player1_field = preload("res://addons/card-framework/pile.tscn").instantiate()
	player1_field.name = "Player1Field"
	player1_field.position = Vector2(400, 400)
	add_child(player1_field)
	
	player2_field = preload("res://addons/card-framework/pile.tscn").instantiate()
	player2_field.name = "Player2Field"
	player2_field.position = Vector2(400, 200)
	add_child(player2_field)
	
	# 创建一些测试卡牌
	create_test_cards()

func create_test_cards():
	# 创建玩家1的卡牌
	var walking_mech = json_factory.create_card("walking_mech", player1_hand)
	var steam_fist = json_factory.create_card("steam_fist", player1_hand)
	var core_drive = json_factory.create_card("core_furnace_drive", player1_hand)
	
	# 创建玩家2的卡牌
	var enemy_mech = json_factory.create_card("walking_mech", player2_hand)
	
	# 更新手牌显示
	player1_hand.update_card_ui()
	player2_hand.update_card_ui()

func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		# 测试抽卡
		draw_card_test()
	elif Input.is_key_pressed(KEY_B):
		# 测试战斗
		battle_test()

func draw_card_test():
	if player1_hand.get_held_cards().size() < player1_hand.max_hand_size:
		var new_card = json_factory.create_card("walking_mech", player1_hand)
		player1_hand.update_card_ui()

func battle_test():
	if player1_field.get_held_cards().size() == 0 and player1_hand.get_held_cards().size() > 0:
		var card = player1_hand.get_held_cards()[0]
		card_manager.move_card(card, player1_field)