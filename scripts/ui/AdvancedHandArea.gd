# 高级手牌区域系统 - 使用曲线控制手牌的扇形和旋转效果
extends Control

var player = null
var card_visuals = []
var is_player_hand = true  # 是否是玩家手牌（用于区分敌我手牌）

# 曲线资源用于控制手牌的Y位置和旋转
@export var hand_y_curve: Curve
@export var rotation_curve: Curve

# 手牌参数
@export var card_width: float = 120
@export var card_height: float = 180
@export var x_separation: float = 20  # 卡牌之间的水平间隔
@export var y_min: float = 0  # Y轴最小偏移
@export var y_max: float = 50  # Y轴最大偏移
@export var max_rotation_degrees: float = 20  # 最大旋转角度

# 卡牌信息显示区域
var card_info_panel = null

func _init(player_obj, is_player=true):
	player = player_obj
	is_player_hand = is_player
	size = Vector2(1920, 180)  # 1080p宽度，手牌区域高度180px

func _ready():
	# 创建卡牌信息面板
	card_info_panel = PanelContainer.new()
	card_info_panel.visible = false
	card_info_panel.self_modulate = Color(0, 0, 0, 0.8)
	
	var info_vbox = VBoxContainer.new()
	card_info_panel.add_child(info_vbox)
	
	add_child(card_info_panel)
	
	# 创建默认曲线（如果没有指定）
	if hand_y_curve == null:
		hand_y_curve = Curve.new()
		hand_y_curve.add_point(Vector2(0, 0))
		hand_y_curve.add_point(Vector2(0.2, 0.5))
		hand_y_curve.add_point(Vector2(0.8, 0.5))
		hand_y_curve.add_point(Vector2(1, 0))
	
	if rotation_curve == null:
		rotation_curve = Curve.new()
		rotation_curve.add_point(Vector2(0, -1))
		rotation_curve.add_point(Vector2(0.5, 0))
		rotation_curve.add_point(Vector2(1, 1))
	
	# 连接窗口大小变化信号
	get_viewport().connect("size_changed", Callable(self, "_on_window_resized"))
	_on_window_resized()

# 窗口大小变化时调整UI
func _on_window_resized():
	var viewport_size = get_viewport_rect().size
	
	if is_player_hand:
		# 调整玩家手牌区域位置到屏幕底部
		position = Vector2(0, viewport_size.y - 180)
		size = Vector2(viewport_size.x, 180)
		
		# 调整信息面板位置到屏幕左上角
		card_info_panel.size = Vector2(200, 300)
		card_info_panel.position = Vector2(20, viewport_size.y - 320)
	else:
		# 调整对手手牌区域位置到屏幕顶部
		position = Vector2(0, 0)
		size = Vector2(viewport_size.x, 180)
		
		# 调整信息面板位置到屏幕右下角
		card_info_panel.size = Vector2(200, 300)
		card_info_panel.position = Vector2(viewport_size.x - 220, 20)

# 更新手牌显示，使用曲线控制扇形排列和卡牌旋转
func update_hand():
	# 清除现有的卡牌可视化
	for visual in card_visuals:
		visual.queue_free()
	card_visuals.clear()
	
	# 获取视口大小
	var viewport_size = get_viewport_rect().size
	
	# 获取卡牌数量
	var card_count = player.hand.size()
	if card_count == 0:
		return
	
	# 计算所有卡牌的总宽度
	var all_cards_size = card_width * card_count + x_separation * (card_count - 1)
	var final_x_sep = x_separation
	
	# 如果总宽度超过容器宽度，则调整间隔
	if all_cards_size > size.x:
		final_x_sep = (size.x - card_width * card_count) / (card_count - 1)
		all_cards_size = size.x
	
	# 计算居中偏移
	var offset = (size.x - all_cards_size) / 2
	
	# 根据是玩家手牌还是对手手牌设置不同的位置
	var base_y
	if is_player_hand:
		base_y = size.y - card_height  # 玩家手牌在底部
	else:
		base_y = 0  # 对手手牌在顶部
	
	# 为每张手牌创建可视化
	for i in range(card_count):
		var card = player.hand[i]
		var card_visual
		
		if is_player_hand:
			# 玩家手牌显示正面
			card_visual = preload("res://scripts/ui/CardVisual.gd").new(card)
		else:
			# 对手手牌显示背面
			card_visual = preload("res://scripts/ui/CardVisual.gd").new(null, true)  # 第二个参数表示显示背面
		
		# 计算在曲线上的位置
		var curve_position = 0.0
		if card_count > 1:
			curve_position = 1.0 / (card_count - 1) * i
		
		# 使用曲线计算Y轴偏移和旋转
		var y_multiplier = hand_y_curve.sample(curve_position)
		var rot_multiplier = rotation_curve.sample(curve_position)
		
		# 特殊处理：如果只有一张卡牌，则居中且不旋转
		if card_count == 1:
			y_multiplier = 0
			rot_multiplier = 0
		
		# 计算最终X位置
		var final_x = offset + card_width * i + final_x_sep * i
		
		# 计算最终Y位置
		var final_y = base_y + y_min + y_max * y_multiplier
		
		card_visual.position = Vector2(final_x, final_y)
		
		# 设置卡牌旋转角度
		card_visual.rotation_degrees = max_rotation_degrees * rot_multiplier
		
		# 只有玩家手牌可以交互
		if is_player_hand:
			card_visual.connect("card_clicked", Callable(self, "_on_card_clicked"))
			card_visual.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			card_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE  # 对手手牌不可交互
		
		add_child(card_visual)
		card_visuals.append(card_visual)

# 处理输入事件
func _input(event):
	if not is_player_hand:  # 对手手牌不处理输入
		return
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			handle_left_click(event)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			handle_right_click(event)

# 处理左键点击
func handle_left_click(event):
	if not is_player_hand:  # 对手手牌不处理点击
		return
		
	# 安全地获取鼠标位置
	var viewport = get_viewport()
	if viewport == null:
		return
		
	var click_position = viewport.get_mouse_position()
	for i in range(card_visuals.size()):
		var card_visual = card_visuals[i]
		if card_visual.get_global_rect().has_point(click_position):
			# 选择卡牌并显示选项
			print("左键点击手牌: ", card_visual.card_data.card_name)
			show_card_info(card_visual.card_data)
			return

# 处理右键点击
func handle_right_click(event):
	if not is_player_hand:  # 对手手牌不处理点击
		return
		
	# 安全地获取鼠标位置
	var viewport = get_viewport()
	if viewport == null:
		return
		
	var click_position = viewport.get_mouse_position()
	for i in range(card_visuals.size()):
		var card_visual = card_visuals[i]
		if card_visual.get_global_rect().has_point(click_position):
			# 选择卡牌并显示选项
			print("右键点击手牌: ", card_visual.card_data.card_name)
			show_card_info(card_visual.card_data)
			return

# 显示卡牌信息
func show_card_info(card_data):
	if not is_player_hand:  # 对手手牌不显示信息
		return
		
	if card_info_panel == null:
		return
	
	# 清除旧的信息
	for child in card_info_panel.get_children():
		child.queue_free()
	
	# 创建信息面板
	var info_panel = PanelContainer.new()
	info_panel.self_modulate = Color(0, 0, 0, 0.8)
	var info_vbox = VBoxContainer.new()
	info_vbox.set("theme_override_constants/separation", 5)
	info_panel.add_child(info_vbox)
	
	# 卡牌名称
	var name_label = Label.new()
	name_label.text = card_data.card_name
	name_label.add_theme_font_size_override("font_size", 16)
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info_vbox.add_child(name_label)
	
	# 卡牌类型
	var type_label = Label.new()
	match card_data.card_type:
		card_data.CardType.MONSTER:
			type_label.text = "类型: 怪兽卡"
		card_data.CardType.SPELL:
			type_label.text = "类型: 法术卡"
		card_data.CardType.POLICY:
			type_label.text = "类型: 政策卡"
		card_data.CardType.COMPONENT:
			type_label.text = "类型: 组件卡"
	type_label.add_theme_font_size_override("font_size", 12)
	info_vbox.add_child(type_label)
	
	# 费用
	var cost_label = Label.new()
	cost_label.text = "费用: " + str(card_data.cost)
	cost_label.add_theme_font_size_override("font_size", 12)
	info_vbox.add_child(cost_label)
	
	# 如果是怪兽卡，显示攻击力和守备力
	if card_data.card_type == card_data.CardType.MONSTER:
		var atk_def_label = Label.new()
		atk_def_label.text = "攻击力/守备力: " + str(card_data.attack) + "/" + str(card_data.defense)
		atk_def_label.add_theme_font_size_override("font_size", 12)
		info_vbox.add_child(atk_def_label)
	
	# 描述
	var desc_label = Label.new()
	desc_label.text = "描述: " + card_data.description
	desc_label.add_theme_font_size_override("font_size", 10)
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	info_vbox.add_child(desc_label)
	
	card_info_panel.add_child(info_panel)
	card_info_panel.visible = true

# 隐藏卡牌信息
func hide_card_info():
	if card_info_panel != null:
		card_info_panel.visible = false

# 处理卡牌点击事件
func _on_card_clicked(card_visual, event):
	if not is_player_hand:  # 对手手牌不处理点击
		return
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			show_card_info(card_visual.card_data)