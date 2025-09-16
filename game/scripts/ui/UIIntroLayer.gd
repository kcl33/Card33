extends CanvasLayer

@onready var bg := $BG
@onready var diagonal_layout := $DiagonalLayout
@onready var top_pink_section := $DiagonalLayout/TopPinkSection
@onready var middle_purple_section := $DiagonalLayout/MiddlePurpleSection
@onready var bottom_pink_section := $DiagonalLayout/BottomPinkSection
@onready var white_stripe1 := $DiagonalLayout/WhiteStripe1
@onready var white_stripe2 := $DiagonalLayout/WhiteStripe2
@onready var title_container := $TitleContainer
@onready var main_title := $TitleContainer/MainTitle
@onready var sub_title := $TitleContainer/SubTitle
@onready var chinese_title := $TitleContainer/ChineseTitle
@onready var menu_container := $MenuContainer
@onready var start_block := $MenuContainer/StartBlock
@onready var continue_block := $MenuContainer/ContinueBlock
@onready var settings_block := $MenuContainer/SettingsBlock
@onready var exit_block := $MenuContainer/ExitBlock

const PunkThemeProfileRes = preload("res://game/scripts/ui/PunkThemeProfile.gd")

var theme_profile
var first_clicked := false

func _ready():
	# 准备主题
	theme_profile = PunkThemeProfileRes.new()
	# 确保在最顶层
	if self is CanvasLayer:
		(self as CanvasLayer).layer = 100

	# 设置背景效果
	_setup_background_effects()
	
	# 设置菜单块样式
	_setup_menu_blocks()
	
	# 初始状态：标题可见，菜单隐藏
	title_container.modulate.a = 0.0
	menu_container.visible = false
	
	# 直接开始开场动画
	await get_tree().create_timer(0.5).timeout
	_start_intro_animation()

func _setup_background_effects():
	# 设置对角线布局的初始状态
	if diagonal_layout:
		diagonal_layout.modulate.a = 0.0
	
	# 设置各个颜色区域
	if top_pink_section:
		top_pink_section.color = Color(0.9, 0, 0.35, 0.9)
	
	if middle_purple_section:
		middle_purple_section.color = Color(0.2, 0.05, 0.3, 0.8)
	
	if bottom_pink_section:
		bottom_pink_section.color = Color(0.9, 0, 0.35, 0.9)
	
	# 设置白色条纹
	if white_stripe1:
		white_stripe1.color = Color(1, 1, 1, 0.8)
	
	if white_stripe2:
		white_stripe2.color = Color(1, 1, 1, 0.8)

func _setup_menu_blocks():
	var blocks = [start_block, continue_block, settings_block, exit_block]
	var colors = [Color(0.9, 0.0, 0.35, 0.8), Color(0.0, 0.0, 0.0, 0.8), Color(0.0, 0.0, 0.0, 0.8), Color(0.0, 0.0, 0.0, 0.8)]
	var button_texts = ["开始游戏", "继续", "设置", "退出"]
	
	for i in range(blocks.size()):
		var block = blocks[i]
		
		# 根据节点类型设置样式
		if block is Button:
			# Button类型：设置按钮样式
			var style = StyleBoxFlat.new()
			style.bg_color = colors[i]
			style.border_color = Color(0.9, 0.0, 0.35, 1)
			style.border_width_left = 3
			style.border_width_top = 3
			style.border_width_right = 3
			style.border_width_bottom = 3
			style.corner_radius_top_left = 0
			style.corner_radius_top_right = 0
			style.corner_radius_bottom_left = 0
			style.corner_radius_bottom_right = 0
			
			block.add_theme_stylebox_override("normal", style)
			block.add_theme_font_size_override("font_size", 28)
			block.add_theme_color_override("font_color", Color(1, 1, 1, 1))
			block.add_theme_color_override("font_outline_color", Color(0, 0, 0, 1))
			block.add_theme_constant_override("outline_size", 2)
			
			# 连接信号
			block.pressed.connect(_on_menu_pressed.bind(button_texts[i]))
			
		elif block is ColorRect:
			# ColorRect类型：设置颜色
			block.color = colors[i]
			
			# 添加点击检测
			block.gui_input.connect(_on_color_rect_clicked.bind(button_texts[i]))
		
		# 初始位置（屏幕外）
		block.position.x = -400

func _start_intro_animation():
	# 第一阶段：对角线布局淡入
	_diagonal_layout_animation()
	
	# 等待背景动画完成
	await get_tree().create_timer(1.0).timeout
	
	# 第二阶段：标题炫酷入场动画
	_title_blast_animation()
	
	await get_tree().create_timer(1.0).timeout
	
	# 第三阶段：显示菜单容器
	menu_container.visible = true
	
	# 菜单按钮滑入 - 阶梯状分布
	_menu_buttons_animation()

func _title_blast_animation():
	# 保存原始变换
	var original_scale = title_container.scale
	var original_rotation = title_container.rotation
	var original_pos = title_container.position
	
	# 初始状态：标题在屏幕外，放大并旋转
	title_container.position = Vector2(-800, original_pos.y)
	title_container.scale = Vector2(3.0, 3.0)
	title_container.rotation = original_rotation + 0.5
	title_container.modulate.a = 0.0
	
	# 第一阶段：快速移动到屏幕中央，同时淡入
	var tween1 = create_tween()
	tween1.parallel().tween_property(title_container, "position", original_pos, 0.6)
	tween1.parallel().tween_property(title_container, "modulate:a", 1.0, 0.6)
	tween1.parallel().tween_property(title_container, "scale", original_scale, 0.6)
	tween1.parallel().tween_property(title_container, "rotation", original_rotation, 0.6)
	tween1.set_trans(Tween.TRANS_BACK)
	tween1.set_ease(Tween.EASE_OUT)
	
	# 第二阶段：轻微弹跳效果
	await tween1.finished
	var tween2 = create_tween()
	tween2.tween_property(title_container, "scale", original_scale * 1.1, 0.2)
	tween2.tween_property(title_container, "scale", original_scale, 0.2)
	tween2.set_trans(Tween.TRANS_ELASTIC)
	tween2.set_ease(Tween.EASE_OUT)

func _diagonal_layout_animation():
	# 对角线布局淡入动画
	var tween = create_tween()
	tween.tween_property(diagonal_layout, "modulate:a", 1.0, 1.0)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)


func _menu_buttons_animation():
	# 菜单按钮动画 - 从右下角倾斜滑入
	var buttons = [
		{"node": start_block, "delay": 0.0, "duration": 0.8, "ease": Tween.EASE_OUT, "move_distance": 600},
		{"node": continue_block, "delay": 0.1, "duration": 0.9, "ease": Tween.EASE_IN_OUT, "move_distance": 650},
		{"node": settings_block, "delay": 0.2, "duration": 0.7, "ease": Tween.EASE_OUT, "move_distance": 700},
		{"node": exit_block, "delay": 0.3, "duration": 0.6, "ease": Tween.EASE_IN, "move_distance": 750}
	]
	
	# 设置按钮初始位置（屏幕外右下角）
	for button_data in buttons:
		button_data.node.position.x = 1200  # 从右侧屏幕外开始
		button_data.node.position.y = 400   # 从下方开始
	
	# 启动按钮动画
	for button_data in buttons:
		_start_delayed_button_animation(button_data.node, button_data.delay, button_data.duration, button_data.ease, button_data.move_distance)

func _start_delayed_button_animation(node: Node, delay: float, duration: float, ease: int, move_distance: float):
	# 创建延迟定时器
	var timer = Timer.new()
	timer.wait_time = delay
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	# 等待延迟时间
	await timer.timeout
	timer.queue_free()
	
	# 开始按钮动画 - 从右下角滑入到最终位置
	var tween = create_tween()
	tween.tween_property(node, "position:x", node.position.x - move_distance, duration)
	tween.tween_property(node, "position:y", node.position.y - 200, duration)
	tween.set_ease(ease)
	tween.set_trans(Tween.TRANS_BACK)

func _on_color_rect_clicked(event: InputEvent, button_text: String):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_menu_pressed(button_text)

func _on_menu_pressed(button_text: String):
	match button_text:
		"开始游戏":
			print("开始游戏")
		"继续":
			print("继续游戏")
		"设置":
			print("打开设置")
		"退出":
			get_tree().quit()
