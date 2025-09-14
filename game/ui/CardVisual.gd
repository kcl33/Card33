extends Control

# 卡牌可视化节点
var card_data = null
var background = null
var name_label = null
var cost_label = null
var type_label = null
var description_label = null
var stats_label = null
var border = null
var is_facedown = false  # 是否为背面朝上

# 颜色定义
const MONSTER_COLOR = Color(0.8, 0.2, 0.2, 0.7)  # 红色
const SPELL_COLOR = Color(0.2, 0.2, 0.8, 0.7)    # 蓝色
const POLICY_COLOR = Color(0.2, 0.8, 0.2, 0.7)   # 绿色
const COMPONENT_COLOR = Color(0.8, 0.8, 0.2, 0.7) # 黄色
const SELECTED_COLOR = Color(1, 1, 0, 0.9)       # 选中时的边框颜色
const FACEDOWN_COLOR = Color(0.2, 0.2, 0.6, 0.8) # 背面颜色

# 信号定义
signal card_clicked(card_visual, event)

func _init(card, facedown=false):
	card_data = card
	is_facedown = facedown
	setup_visual()

# 设置卡牌可视化
func setup_visual():
	# 设置大小（根据屏幕大小自适应）
	var base_width = 120
	var base_height = 180
	
	# 获取视口大小来计算缩放因子
	var viewport_size = get_viewport_rect().size
	var scale_factor = min(viewport_size.x / 1024.0, viewport_size.y / 768.0)
	scale_factor = clamp(scale_factor, 0.8, 1.5)  # 限制缩放范围
	
	size = Vector2(base_width * scale_factor, base_height * scale_factor)
	
	# 创建背景
	background = ColorRect.new()
	background.size = size
	add_child(background)
	
	if is_facedown:
		# 显示背面
		background.color = FACEDOWN_COLOR
		# 可以添加背面图案或纹理
	else:
		# 显示正面
		if card_data != null:
			# 根据卡牌类型设置颜色
			match card_data.card_type:
				card_data.CardType.MONSTER:
					background.color = MONSTER_COLOR
				card_data.CardType.SPELL:
					background.color = SPELL_COLOR
				card_data.CardType.POLICY:
					background.color = POLICY_COLOR
				card_data.CardType.COMPONENT:
					background.color = COMPONENT_COLOR
		else:
			background.color = Color(0.5, 0.5, 0.5, 0.7)  # 默认灰色
	
	if not is_facedown and card_data != null:
		# 只有正面且有数据时才显示卡牌信息
		# 创建名称标签
		name_label = Label.new()
		name_label.text = card_data.card_name
		name_label.position = Vector2(5, 5)
		name_label.add_theme_font_size_override("font_size", int(12 * scale_factor))
		add_child(name_label)
		
		# 创建费用标签
		cost_label = Label.new()
		cost_label.text = str(card_data.cost)
		cost_label.position = Vector2(size.x - 25, 5)
		cost_label.add_theme_font_size_override("font_size", int(14 * scale_factor))
		cost_label.add_theme_color_override("font_color", Color(1, 1, 1))
		add_child(cost_label)
		
		# 创建类型标签
		type_label = Label.new()
		type_label.position = Vector2(5, 25)
		type_label.add_theme_font_size_override("font_size", int(10 * scale_factor))
		add_child(type_label)
		
		# 根据类型设置显示文本
		match card_data.card_type:
			card_data.CardType.MONSTER:
				type_label.text = "怪兽"
				# 显示攻击力/守备力
				stats_label = Label.new()
				stats_label.text = str(card_data.attack) + "/" + str(card_data.defense)
				stats_label.position = Vector2(5, size.y - 25)
				stats_label.add_theme_font_size_override("font_size", int(12 * scale_factor))
				add_child(stats_label)
			card_data.CardType.SPELL:
				type_label.text = "法术"
			card_data.CardType.POLICY:
				type_label.text = "政策"
			card_data.CardType.COMPONENT:
				type_label.text = "组件"
				# 显示组件类型
				if card_data.component_type != null:
					var component_text = ""
					match card_data.component_type:
						card_data.ComponentType.WEAPON:
							component_text = "武器"
						card_data.ComponentType.MOBILITY:
							component_text = "移动"
						card_data.ComponentType.DEFENSE:
							component_text = "防御"
						card_data.ComponentType.UTILITY:
							component_text = "实用"
					var subtype_label = Label.new()
					subtype_label.text = component_text
					subtype_label.position = Vector2(5, 40)
					subtype_label.add_theme_font_size_override("font_size", int(10 * scale_factor))
					add_child(subtype_label)
		
		# 创建描述标签
		description_label = Label.new()
		description_label.text = card_data.description
		description_label.position = Vector2(5, size.y - 80)
		description_label.size = Vector2(size.x - 10, 60)
		description_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		description_label.add_theme_font_size_override("font_size", int(8 * scale_factor))
		description_label.add_theme_color_override("font_color", Color(1, 1, 1))
		add_child(description_label)
	
	# 添加边框
	border = ColorRect.new()
	border.size = Vector2(size.x, size.y)
	border.color = Color(0, 0, 0, 1)
	border.position = Vector2(-1, -1)
	border.size = Vector2(size.x + 2, size.y + 2)
	add_child(border, true)
	
	# 启用输入（仅正面卡牌）
	if not is_facedown:
		mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

# 处理输入事件
func _gui_input(event):
	# 只有正面卡牌可以交互
	if is_facedown:
		return
		
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
			# 点击卡牌时发出信号
			emit_signal("card_clicked", self, event)

# 显示上下文菜单
func show_context_menu():
	# 只有正面卡牌可以显示菜单
	if is_facedown:
		return
		
	# 这里应该显示一个实际的菜单
	# 简化处理，只打印选项
	print("显示卡牌菜单: ", card_data.card_name)
	print("- 使用效果")
	if card_data.card_type == card_data.CardType.MONSTER:
		print("- 召唤（攻击表示）")
		print("- 召唤（守备表示）")
	print("- 查看详情")

# 更新卡牌显示
func update_display():
	if is_facedown or card_data == null:
		return
		
	name_label.text = card_data.card_name
	cost_label.text = str(card_data.cost)
	
	# 如果是怪兽卡，更新攻击力/守备力
	if card_data.card_type == card_data.CardType.MONSTER and stats_label != null:
		stats_label.text = str(card_data.attack) + "/" + str(card_data.defense)

# 设置选中状态
func set_selected(selected):
	if selected:
		border.color = SELECTED_COLOR
	else:
		border.color = Color(0, 0, 0, 1)
