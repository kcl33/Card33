class_name MainGameUI
extends Control

# 玩家信息面板
@onready var player_info_panel = $PlayerInfoPanel
@onready var player_lp_label = $PlayerInfoPanel/LPLabel
@onready var player_mana_label = $PlayerInfoPanel/ManaLabel
@onready var player_armor_label = $PlayerInfoPanel/ArmorLabel
@onready var player_extra_points_label = $PlayerInfoPanel/ExtraPointsLabel

# 对手信息面板
@onready var opponent_info_panel = $OpponentInfoPanel
@onready var opponent_lp_label = $OpponentInfoPanel/LPLabel
@onready var opponent_mana_label = $OpponentInfoPanel/ManaLabel
@onready var opponent_armor_label = $OpponentInfoPanel/ArmorLabel
@onready var opponent_extra_points_label = $OpponentInfoPanel/ExtraPointsLabel

# 游戏信息面板
@onready var game_info_panel = $GameInfoPanel
@onready var phase_label = $GameInfoPanel/PhaseLabel
@onready var turn_label = $GameInfoPanel/TurnLabel

# 手牌区域
@onready var hand_container = $HandContainer

# 场地容器
@onready var player_field_container = $PlayerFieldContainer
@onready var opponent_field_container = $OpponentFieldContainer

# 墓地和卡组显示
@onready var player_graveyard_pile = $PlayerGraveyardPile
@onready var player_deck_pile = $PlayerDeckPile
@onready var opponent_graveyard_pile = $OpponentGraveyardPile
@onready var opponent_deck_pile = $OpponentDeckPile

# 教程信息面板
@onready var tutorial_panel = $TutorialPanel
@onready var tutorial_message_label = $TutorialPanel/MessageLabel
@onready var tutorial_continue_button = $TutorialPanel/ContinueButton

# 按钮
@onready var next_phase_button = $ControlPanel/NextPhaseButton
@onready var draw_card_button = $ControlPanel/DrawCardButton
@onready var menu_button = $ControlPanel/MenuButton

var game_manager: GameManager
var player: Player
var opponent: Player
var tutorial_manager: TutorialManager

signal open_menu_requested

func _ready():
	hide_tutorial()
	tutorial_continue_button.connect("pressed", self, "_on_tutorial_continue_pressed")
	next_phase_button.connect("pressed", self, "_on_next_phase_pressed")
	draw_card_button.connect("pressed", self, "_on_draw_card_pressed")
	menu_button.connect("pressed", self, "_on_menu_pressed")

func setup_ui(gm: GameManager, p: Player, o: Player, tm: TutorialManager):
	game_manager = gm
	player = p
	opponent = o
	tutorial_manager = tm
	
	# 连接游戏管理器信号
	game_manager.connect("phase_changed", self, "_on_game_phase_changed")
	game_manager.connect("game_ended", self, "_on_game_ended")
	
	# 连接教程管理器信号
	tutorial_manager.connect("tutorial_step_completed", self, "_on_tutorial_step_completed")
	
	# 初始化UI
	update_player_info()
	update_opponent_info()
	update_game_info()
	update_control_buttons()

func update_player_info():
	player_lp_label.text = "LP: %d" % player.lp
	player_mana_label.text = "Mana: %d/%d" % [player.mana_current, player.mana_max]
	player_armor_label.text = "Armor: %d" % player.armor
	player_extra_points_label.text = "EX: %d" % player.extra_points

func update_opponent_info():
	opponent_lp_label.text = "LP: %d" % opponent.lp
	opponent_mana_label.text = "Mana: %d/%d" % [opponent.mana_current, opponent.mana_max]
	opponent_armor_label.text = "Armor: %d" % opponent.armor
	opponent_extra_points_label.text = "EX: %d" % opponent.extra_points

func update_game_info():
	match game_manager.current_phase:
		GameManager.GamePhase.START_PHASE:
			phase_label.text = "开始阶段"
		GameManager.GamePhase.DRAW_PHASE:
			phase_label.text = "抽牌阶段"
		GameManager.GamePhase.MANA_PHASE:
			phase_label.text = "费用阶段"
		GameManager.GamePhase.MAIN_PHASE_1:
			phase_label.text = "主要阶段1"
		GameManager.GamePhase.BATTLE_PHASE:
			phase_label.text = "战斗阶段"
		GameManager.GamePhase.MAIN_PHASE_2:
			phase_label.text = "主要阶段2"
		GameManager.GamePhase.END_PHASE:
			phase_label.text = "结束阶段"
	
	turn_label.text = "回合: %d" % game_manager.turn_count

func update_control_buttons():
	# 根据当前游戏阶段更新控制按钮状态
	match game_manager.current_phase:
		GameManager.GamePhase.DRAW_PHASE:
			draw_card_button.disabled = false
		_:
			draw_card_button.disabled = true
	
	# 在某些阶段允许手动进入下一阶段
	if game_manager.current_phase in [GameManager.GamePhase.MAIN_PHASE_1, GameManager.GamePhase.BATTLE_PHASE, GameManager.GamePhase.MAIN_PHASE_2]:
		next_phase_button.disabled = false
	else:
		next_phase_button.disabled = true

func _on_game_phase_changed(phase):
	update_player_info()
	update_opponent_info()
	update_game_info()
	update_control_buttons()
	
	# 根据教程步骤显示提示信息
	if tutorial_manager.is_tutorial_active():
		match phase:
			GameManager.GamePhase.START_PHASE:
				if tutorial_manager.get_current_step() == 0:
					show_tutorial_message("回合开始！额外点数已恢复。")
			GameManager.GamePhase.DRAW_PHASE:
				if tutorial_manager.get_current_step() == 1:
					show_tutorial_message("现在是抽牌阶段，点击'抽牌'按钮抽一张牌。")
			GameManager.GamePhase.MANA_PHASE:
				if tutorial_manager.get_current_step() == 2:
					show_tutorial_message("费用阶段：费用上限增加并补满费用。")

func _on_game_ended(winner):
	var winner_name = "玩家" if winner == player else "对手"
	show_tutorial_message("游戏结束！%s 获胜！" % winner_name)

func show_tutorial_message(message: String):
	tutorial_panel.show()
	tutorial_message_label.text = message

func hide_tutorial():
	tutorial_panel.hide()

func _on_tutorial_continue_pressed():
	tutorial_panel.hide()

func _on_next_phase_pressed():
	game_manager.next_phase()

func _on_draw_card_pressed():
	# 直接从卡组抽一张牌
	game_manager.draw_cards(game_manager.turn_player, 1)
	# 更新UI
	update_player_info()

func _on_menu_pressed():
	emit_signal("open_menu_requested")

func _on_tutorial_step_completed(step):
	match step:
		0:
			show_tutorial_message("很好！现在点击'下一阶段'按钮进入抽牌阶段。")
		1:
			show_tutorial_message("抽牌完成！现在进入费用阶段。")
		2:
			show_tutorial_message("费用增加完成！现在你可以召唤单位或使用法术。")