extends CanvasLayer

@onready var bg := $BG
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

	# 设置标题样式（异步）
	await _setup_title_style()
	
	# 设置菜单块样式
	_setup_menu_blocks()
	
	# 初始状态：标题可见，菜单隐藏
	title_container.modulate.a = 0.0
	menu_container.visible = false
	
	# 引导点击提示
	set_process_unhandled_input(true)

func _setup_title_style():
	# 等待一帧确保节点完全初始化
	await get_tree().process_frame
	
	# 尝试加载字体，如果失败则使用默认字体
	var custom_font = null
	if FileAccess.file_exists("res://res/fonts/BetterPixels.ttf"):
		custom_font = load("res://res/fonts/BetterPixels.ttf")
	
	# 主标题 - 最大字体，粗体描边
	if main_title:
		main_title.add_theme_font_size_override("font_size", 72)
		main_title.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		main_title.add_theme_color_override("font_outline_color", Color(0.9, 0.0, 0.35, 1))
		main_title.add_theme_constant_override("outline_size", 6)  # 更粗的描边
		if custom_font:
			main_title.add_theme_font_override("font", custom_font)
	
	# 副标题 - 中等字体，中等描边
	if sub_title:
		sub_title.add_theme_font_size_override("font_size", 56)
		sub_title.add_theme_color_override("font_color", Color(1, 1, 1, 1))
		sub_title.add_theme_color_override("font_outline_color", Color(0.9, 0.0, 0.35, 1))
		sub_title.add_theme_constant_override("outline_size", 4)
		if custom_font:
			sub_title.add_theme_font_override("font", custom_font)
	
	# 中文标题 - 小字体，细描边
	if chinese_title:
		chinese_title.add_theme_font_size_override("font_size", 32)
		chinese_title.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8, 1))
		chinese_title.add_theme_color_override("font_outline_color", Color(0.9, 0.0, 0.35, 0.8))
		chinese_title.add_theme_constant_override("outline_size", 2)
		if custom_font:
			chinese_title.add_theme_font_override("font", custom_font)

func _setup_menu_blocks():
	var blocks = [start_block, continue_block, settings_block, exit_block]
	var colors = [Color(0.9, 0.0, 0.35, 0.8), Color(0.0, 0.0, 0.0, 0.8), Color(0.0, 0.0, 0.0, 0.8), Color(0.0, 0.0, 0.0, 0.8)]
	
	for i in range(blocks.size()):
		var block = blocks[i]
		
		# 设置按钮样式
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
		block.pressed.connect(_on_menu_pressed.bind(block.text))
		
		# 初始位置（屏幕外）
		block.position.x = -400

func _unhandled_input(event):
	if first_clicked:
		return
	if event is InputEventMouseButton and event.pressed:
		first_clicked = true
		_reveal_sequence()

func _reveal_sequence():
	# 标题淡入
	var title_tween = create_tween()
	title_tween.tween_property(title_container, "modulate:a", 1.0, 0.8)
	
	await get_tree().create_timer(0.5).timeout
	
	# 显示菜单容器
	menu_container.visible = true
	
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