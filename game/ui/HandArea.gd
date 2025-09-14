extends Control

var player = null
var card_visuals = []
var card_positions = []
var is_player_hand = true  # 是否是玩家手牌（用于区分敌我手牌）

# 卡牌信息显示区域
var card_info_panel = null

func _init(player_obj, is_player=true):
	player = player_obj
	is_player_hand = is_player

func _ready():
	# 创建卡牌信息面板
	card_info_panel = PanelContainer.new()
	card_info_panel.visible = false
	card_info_panel.self_modulate = Color(0, 0, 0, 0.8)
	
	var info_vbox = VBoxContainer.new()
	card_info_panel.add_child(info_vbox)
	
	add_child(card_info_panel)
	
	# 连接窗口大小变化信号
	get_viewport().connect("size_changed", Callable(self, "_on_window_resized"))
	_on_window_resized()

# 窗口大小变化时调整UI
func _on_window_resized():
	var viewport_size = get_viewport_rect().size
	
	if is_player_hand:
		# 调整玩家手牌区域位置到屏幕底部中央
		position = Vector2(0, viewport_size.y - 200)
		size = Vector2(viewport_size.x, 200)
		
		# 调整信息面板位置到屏幕左上角
		card_info_panel.size = Vector2(200, 300)
		card_info_panel.position = Vector2(20, 20)
	else:
		# 调整对手手牌区域位置到屏幕顶部中央
		position = Vector2(0, 0)
		size = Vector2(viewport_size.x, 200)

# 更新手牌显示，实现扇形排列和卡牌旋转
func update_hand():
	# 清除现有的卡牌可视化
	for visual in card_visuals:
		visual.queue_free()
	card_visuals.clear()
	card_positions.clear()
	
	# 获取视口大小
	var viewport_size = get_viewport_rect().size
	
	# 计算扇形排列参数
	var card_count = player.hand.size()
	if card_count == 0:
		return
	
	# 扇形参数
	var radius = min(viewport_size.x * 0.3, 200.0)
	var center_x = viewport_size.x / 2
	
	# 根据是玩家手牌还是对手手牌设置不同的位置
	var center_y
	if is_player_hand:
		center_y = viewport_size.y - 100  # 玩家手牌在底部
	else:
		center_y = 100  # 对手手牌在顶部
	
	var start_angle = -PI/4
	var end_angle = PI/4
	var angle_step = 0.0
	
	if card_count > 1:
		angle_step = (end_angle - start_angle) / (card_count - 1)
	else:
		start_angle = 0.0
	
	# 为每张手牌创建可视化
	for i in range(card_count):
		var card = player.hand[i]
		var card_visual
		
		if is_player_hand:
			# 玩家手牌显示正面
			card_visual = CardVisual.new(card)
		else:
			# 对手手牌显示背面
			card_visual = CardVisual.new(null, true)  # 第二个参数表示显示背面
		
		# 计算扇形位置
		var angle = start_angle + i * angle_step
		var x = center_x + radius * sin(angle)
		var y = center_y - radius * cos(angle)
		
		card_visual.position = Vector2(x, y)
		card_positions.append(Vector2(x, y))
		
		# 设置卡牌旋转角度，营造自然的手牌效果
		var rotation_angle = angle * 0.5  # 旋转角度是位置角度的一半，看起来更自然
		card_visual.rotation = rotation_angle
		
		# 只有玩家手牌可以交互
		if is_player_hand:
			card_visual.connect("card_clicked", Callable(self, "_on_card_clicked"))
			card_visual.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			card_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE

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