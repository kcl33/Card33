extends CanvasLayer

@onready var bg := $BG
@onready var contour := $Contour
@onready var stripes := $Stripes
@onready var dots := $Dots
@onready var rain := $Rain
@onready var background_shapes := $BackgroundShapes
@onready var rect1 := $BackgroundShapes/Rect1
@onready var rect2 := $BackgroundShapes/Rect2
@onready var rect3 := $BackgroundShapes/Rect3
@onready var rect4 := $BackgroundShapes/Rect4
@onready var rect5 := $BackgroundShapes/Rect5
@onready var line1 := $BackgroundShapes/Line1
@onready var line2 := $BackgroundShapes/Line2
@onready var line3 := $BackgroundShapes/Line3
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
	# 设置等高线背景
	if contour:
		contour.color = Color(0.05, 0.05, 0.05, 1)
	
	# 设置条纹效果（极淡）
	if stripes:
		stripes.color = Color(1, 1, 1, 0.08)
	
	# 设置灰点效果（极淡）
	if dots:
		dots.color = Color(1, 1, 1, 0.12)
	
	# 雨滴效果（初始隐藏）
	if rain:
		rain.color = Color(0, 0, 0, 0.3)
		rain.visible = false

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
	# 第一阶段：背景形状先进入
	_background_shapes_animation()
	
	# 等待背景形状动画完成
	await get_tree().create_timer(1.2).timeout
	
	# 第二阶段：标题炫酷入场动画
	_title_blast_animation()
	
	await get_tree().create_timer(1.0).timeout
	
	# 第三阶段：显示菜单容器
	menu_container.visible = true
	
	# 激活雨滴效果
	if rain:
		rain.visible = true
	
	# 菜单块依次滑入
	var blocks = [start_block, continue_block, settings_block, exit_block]
	for i in range(blocks.size()):
		var block = blocks[i]
		var target_x = block.position.x + 400
		var tween = create_tween()
		tween.tween_property(block, "position:x", target_x, 0.4)
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		await get_tree().create_timer(0.1).timeout

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

func _background_shapes_animation():
	# 矩形形状动画 - 每个都有不同的速度和延迟
	var shapes = [
		{"node": rect1, "delay": 0.0, "duration": 0.8, "ease": Tween.EASE_OUT},
		{"node": rect2, "delay": 0.1, "duration": 1.0, "ease": Tween.EASE_IN_OUT},
		{"node": rect3, "delay": 0.2, "duration": 0.6, "ease": Tween.EASE_OUT},
		{"node": rect4, "delay": 0.15, "duration": 0.9, "ease": Tween.EASE_IN},
		{"node": rect5, "delay": 0.3, "duration": 0.7, "ease": Tween.EASE_OUT}
	]
	
	# 线条动画
	var lines = [
		{"node": line1, "delay": 0.05, "duration": 0.5, "ease": Tween.EASE_OUT},
		{"node": line2, "delay": 0.25, "duration": 0.6, "ease": Tween.EASE_IN_OUT},
		{"node": line3, "delay": 0.1, "duration": 0.4, "ease": Tween.EASE_OUT}
	]
	
	# 启动矩形动画
	for shape_data in shapes:
		var tween = create_tween()
		tween.tween_delay(shape_data.delay)
		tween.tween_property(shape_data.node, "position:x", shape_data.node.position.x + 500, shape_data.duration)
		tween.set_ease(shape_data.ease)
		tween.set_trans(Tween.TRANS_QUART)
	
	# 启动线条动画
	for line_data in lines:
		var tween = create_tween()
		tween.tween_delay(line_data.delay)
		tween.tween_property(line_data.node, "position:x", line_data.node.position.x + 400, line_data.duration)
		tween.set_ease(line_data.ease)
		tween.set_trans(Tween.TRANS_CUBIC)

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
