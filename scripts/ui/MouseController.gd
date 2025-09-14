extends Node

# 鼠标交互控制器
var selected_card = null
var drag_start_position = Vector2.ZERO
var is_dragging = false
var game_controller = null
var hand_areas = {}

# 信号定义
signal card_selected(card)
signal card_deselected()
signal card_played(card, position)

func _init(controller):
	game_controller = controller

# 设置手牌区域
func set_hand_areas(player1_area, player2_area):
	hand_areas[1] = player1_area
	hand_areas[2] = player2_area

# 处理鼠标输入
func handle_mouse_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# 左键按下
				handle_left_click_press(event)
			else:
				# 左键释放
				handle_left_click_release(event)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				# 右键按下
				handle_right_click_press(event)
			else:
				# 右键释放
				handle_right_click_release(event)
	elif event is InputEventMouseMotion:
		if is_dragging:
			handle_drag_motion(event)

# 处理左键按下
func handle_left_click_press(event):
	# 安全地获取鼠标位置
	var viewport = get_viewport()
	if viewport == null:
		return
	
	var target = viewport.get_mouse_position()
	# 检查是否点击了手牌
	for player_id in hand_areas:
		var hand_area = hand_areas[player_id]
		for card_visual in hand_area.card_visuals:
			if card_visual.get_global_rect().has_point(target):
				select_card(card_visual.card_data)
				drag_start_position = event.position
				is_dragging = true
				return

# 处理左键释放
func handle_left_click_release(event):
	if is_dragging:
		# 安全地获取鼠标位置
		var viewport = get_viewport()
		if viewport == null:
			deselect_card()
			is_dragging = false
			return
			
		# 检查是否拖拽到了场上
		var target_position = viewport.get_mouse_position()
		var field_area = Rect2(Vector2(100, 200), Vector2(600, 200))  # 简化的场上区域
		
		if field_area.has_point(target_position):
			# 拖拽到场上，正面攻击表示召唤
			if selected_card != null:
				play_card(selected_card, selected_card.Position.ATTACK)
		
		deselect_card()
		is_dragging = false

# 处理右键按下
func handle_right_click_press(event):
	# 安全地获取鼠标位置
	var viewport = get_viewport()
	if viewport == null:
		return
		
	var target = viewport.get_mouse_position()
	# 检查是否点击了手牌
	for player_id in hand_areas:
		var hand_area = hand_areas[player_id]
		for card_visual in hand_area.card_visuals:
			if card_visual.get_global_rect().has_point(target):
				select_card(card_visual.card_data)
				drag_start_position = event.position
				is_dragging = true
				return

# 处理右键释放
func handle_right_click_release(event):
	if is_dragging:
		# 安全地获取鼠标位置
		var viewport = get_viewport()
		if viewport == null:
			deselect_card()
			is_dragging = false
			return
			
		# 检查是否拖拽到了场上
		var target_position = viewport.get_mouse_position()
		var field_area = Rect2(Vector2(100, 200), Vector2(600, 200))  # 简化的场上区域
		
		if field_area.has_point(target_position):
			# 拖拽到场上，里侧守备表示召唤
			if selected_card != null:
				play_card(selected_card, selected_card.Position.DEFENSE)
		
		deselect_card()
		is_dragging = false

# 处理拖拽移动
func handle_drag_motion(event):
	# 可以在这里添加拖拽时的视觉反馈
	pass

# 选择卡牌
func select_card(card):
	selected_card = card
	emit_signal("card_selected", card)
	print("选择了卡牌: ", card.card_name)

# 取消选择卡牌
func deselect_card():
	selected_card = null
	emit_signal("card_deselected")
	print("取消选择卡牌")

# 打出卡牌
func play_card(card, position):
	# 确定当前玩家
	var current_player = game_controller.player1 if game_controller.current_player == 1 else game_controller.player2
	
	# 检查玩家是否拥有这张卡
	if not current_player.hand.has(card):
		print("玩家手牌中没有这张卡")
		return false
	
	# 尝试打出卡牌
	var result = current_player.play_card(card, position)
	if result == true:
		print("成功打出卡牌: ", card.card_name)
		# 更新手牌显示
		if hand_areas.has(game_controller.current_player):
			hand_areas[game_controller.current_player].update_hand()
		emit_signal("card_played", card, position)
		return true
	elif result == false:
		print("无法打出卡牌: ", card.card_name)
		return false
	else:
		# 需要选择目标（如组件卡）
		print("需要选择目标来安装组件")
		return "select_target"

# 显示卡牌选项菜单
func show_card_options(card, position):
	# 这里应该显示一个上下文菜单
	# 简化处理，只打印选项
	print("卡牌选项:")
	print("1. 使用效果")
	print("2. 召唤到场上")
	if card.card_type == card.CardType.MONSTER:
		print("3. 里侧守备表示召唤")
