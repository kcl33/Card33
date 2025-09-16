extends CanvasLayer

@onready var background := $Background
@onready var background_effect := $BackgroundEffect
@onready var rain_effect := $RainEffect
@onready var gradient_overlay := $GradientOverlay
@onready var bgm_player := $BGMPlayer
@onready var geometric_elements := $GeometricElements
@onready var triangle1 := $GeometricElements/Triangle1
@onready var triangle2 := $GeometricElements/Triangle2
@onready var triangle3 := $GeometricElements/Triangle3
@onready var line1 := $GeometricElements/Line1
@onready var line2 := $GeometricElements/Line2
# StripeMasks nodes removed - no longer used
@onready var title_container := $TitleContainer
@onready var title_background := $TitleContainer/TitleBackground
@onready var ink_splash1 := $TitleContainer/InkSplash1
@onready var ink_splash2 := $TitleContainer/InkSplash2
# GlitchLine nodes removed - no longer exist in scene
@onready var main_title := $TitleContainer/EnglishTitle/MainTitle
@onready var sub_title := $TitleContainer/EnglishTitle/SubTitle
@onready var english_title := $TitleContainer/EnglishTitle
# PressButtonPrompt node removed - no longer used
@onready var menu_container := $MenuContainer
@onready var start_button := $MenuContainer/StartButton
@onready var continue_button := $MenuContainer/ContinueButton
@onready var settings_button := $MenuContainer/SettingsButton
@onready var exit_button := $MenuContainer/ExitButton

const PunkThemeProfileRes = preload("res://game/scripts/ui/PunkThemeProfile.gd")

var theme_profile
var first_clicked := false

func _ready():
	# 确保在最顶层
	if self is CanvasLayer:
		(self as CanvasLayer).layer = 100

	# 调试信息
	print("UIIntroLayer ready")
	print("Background: ", background)
	print("BackgroundEffect: ", background_effect)
	print("TitleContainer: ", title_container)
	print("MenuContainer: ", menu_container)

	# 检查关键节点是否存在
	if not background:
		print("ERROR: Background node not found!")
		return
	if not background_effect:
		print("ERROR: BackgroundEffect node not found!")
		return
	if not title_container:
		print("ERROR: TitleContainer node not found!")
		return
	if not menu_container:
		print("ERROR: MenuContainer node not found!")
		return

	# 设置背景效果
	_setup_background_effects()
	
	# 设置雨滴效果
	_setup_rain_effects()
	
	# 设置渐变遮罩
	_setup_gradient_overlay()
	
	# 设置BGM
	_setup_bgm()
	
	# 设置菜单按钮
	_setup_menu_buttons()
	
	# 初始状态：所有元素隐藏
	if title_container:
		title_container.modulate.a = 0.0
	if menu_container:
		menu_container.modulate.a = 0.0
	if geometric_elements:
		geometric_elements.modulate.a = 0.0
	
	# 特别设置CAPROS图片初始状态
	if main_title:
		main_title.modulate.a = 0.0
		main_title.visible = true
		print("设置CAPROS图片初始状态 - 透明度: ", main_title.modulate.a, " 可见性: ", main_title.visible)
	
	# 连接输入事件
	set_process_input(true)
	
	# 显示主菜单，不自动启动序章
	print("主菜单准备完成，等待用户点击开始游戏...")

func _setup_background_effects():
	# 设置背景shader材质
	if background_effect:
		print("Setting up background shader...")
		var shader_material = ShaderMaterial.new()
		var shader = preload("res://res/shaders/P3RBackground.gdshader")
		if shader:
			shader_material.shader = shader
			shader_material.set_shader_parameter("time_scale", 1.0)
			shader_material.set_shader_parameter("wave_amplitude", 0.1)
			shader_material.set_shader_parameter("wave_frequency", 2.0)
			shader_material.set_shader_parameter("gradient_speed", 1.0)
			shader_material.set_shader_parameter("noise_scale", 5.0)
			shader_material.set_shader_parameter("noise_strength", 0.3)
			background_effect.material = shader_material
			print("Background shader set successfully")
		else:
			print("Failed to load shader")
	else:
		print("BackgroundEffect node not found")

func _setup_rain_effects():
	# 设置雨滴效果
	if rain_effect:
		print("Setting up rain shader...")
		var rain_shader = load("res://res/shaders/RainEffect.gdshader")
		if rain_shader:
			var rain_material = ShaderMaterial.new()
			rain_material.shader = rain_shader
			rain_effect.material = rain_material
			
			# 随机选择小雨或暴雨
			var is_heavy_rain = randf() > 0.5
			var rain_intensity = 0.3 if not is_heavy_rain else 0.8
			var rain_speed = 1.5 if not is_heavy_rain else 3.0
			
			print("雨滴类型: ", "暴雨" if is_heavy_rain else "小雨")
			print("雨滴强度: ", rain_intensity)
			
			# 设置shader参数
			rain_material.set_shader_parameter("time_scale", 1.0)
			rain_material.set_shader_parameter("rain_intensity", rain_intensity)
			rain_material.set_shader_parameter("rain_speed", rain_speed)
			rain_material.set_shader_parameter("rain_size", 1.2) # 稍微大一点的雨滴
			rain_material.set_shader_parameter("rain_opacity", 1.0) # 完全不透明，纯白色
			rain_material.set_shader_parameter("rain_color", Color(1.0, 1.0, 1.0, 1.0)) # 纯白色
		else:
			print("Failed to load rain shader, using fallback")
			rain_effect.color = Color(0.0, 0.0, 0.0, 0.0)  # 透明作为备用
		
		print("Rain shader setup complete")
	else:
		print("RainEffect node not found")

func _setup_gradient_overlay():
	# 设置渐变遮罩
	if gradient_overlay:
		print("Setting up gradient overlay...")
		# 创建渐变shader
		var gradient_shader = Shader.new()
		gradient_shader.code = """
		shader_type canvas_item;
		
		void fragment() {
			vec2 uv = UV;
			
			// 从上到下轻微变暗
			float vertical_gradient = 1.0 - uv.y * 0.1;
			vertical_gradient = max(vertical_gradient, 0.9);
			
			// 右半部分透明度降低（为主角图片留空间）
			float horizontal_gradient = 1.0;
			if (uv.x > 0.5) {
				// 右半部分逐渐变透明
				float right_factor = (uv.x - 0.5) * 2.0; // 0.5到1.0映射到0.0到1.0
				horizontal_gradient = 1.0 - right_factor * 0.6; // 右半部分透明度降低60%
			}
			
			// 组合垂直和水平渐变
			float final_gradient = vertical_gradient * horizontal_gradient;
			COLOR = vec4(0.0, 0.0, 0.0, final_gradient * 0.3);
		}
		"""
		
		var gradient_material = ShaderMaterial.new()
		gradient_material.shader = gradient_shader
		gradient_overlay.material = gradient_material
		
		print("Gradient overlay setup complete")
	else:
		print("GradientOverlay node not found")

func _setup_bgm():
	# 设置BGM播放
	if bgm_player:
		print("Setting up BGM...")
		bgm_player.volume_db = -8.0  # 稍微调大音量
		bgm_player.autoplay = true
		bgm_player.play()
		print("BGM started playing")
	else:
		print("BGMPlayer node not found")

func _setup_menu_buttons():
	# 连接按钮信号
	print("Setting up menu buttons...")
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
		start_button.mouse_entered.connect(_on_button_hover.bind(start_button))
		start_button.mouse_exited.connect(_on_button_unhover.bind(start_button))
		print("Start button connected")
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)
		continue_button.mouse_entered.connect(_on_button_hover.bind(continue_button))
		continue_button.mouse_exited.connect(_on_button_unhover.bind(continue_button))
		print("Continue button connected")
	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)
		settings_button.mouse_entered.connect(_on_button_hover.bind(settings_button))
		settings_button.mouse_exited.connect(_on_button_unhover.bind(settings_button))
		print("Settings button connected")
	if exit_button:
		exit_button.pressed.connect(_on_exit_pressed)
		exit_button.mouse_entered.connect(_on_button_hover.bind(exit_button))
		exit_button.mouse_exited.connect(_on_button_unhover.bind(exit_button))
		print("Exit button connected")

func _start_p3r_intro_animation():
	# 第一阶段：几何元素动画
	
	# 第二阶段：几何元素淡入
	_geometric_elements_animation()
	
	# 等待几何元素动画完成
	await get_tree().create_timer(1.0).timeout
	
	# 第三阶段：标题渐入动画
	_title_fade_in_animation()
	
	await get_tree().create_timer(1.0).timeout
	
	# 第四阶段：PRESS ANY BUTTON提示已移除
	await get_tree().create_timer(1.0).timeout
	
	# 第五阶段：菜单按钮渐入
	_menu_fade_in_animation()

# Stripe masks functions removed - no longer used

func _geometric_elements_animation():
	# 几何元素动态浮现动画
	if not geometric_elements:
		print("ERROR: GeometricElements node not found in animation!")
		return
		
	var tween = create_tween()
	tween.parallel().tween_property(geometric_elements, "modulate:a", 1.0, 1.5)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	
	# 启动各个几何元素的独立动画
	_start_triangle_animations()
	_start_line_animations()

func _title_fade_in_animation():
	# 标题渐入动画
	var tween = create_tween()
	# 先让整个标题容器显示
	tween.parallel().tween_property(title_container, "modulate:a", 1.0, 1.0)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	
	# 启动墨迹背景动画
	_start_ink_background_animations()
	
	# 等待标题容器显示完成后再启动CAPROS图片动画
	await tween.finished
	await get_tree().create_timer(0.5).timeout
	
	# 直接启动CAPROS图片卡片滑入动画
	_start_simple_card_slide()

# Press button functions removed - node no longer exists

# Glitch effects removed - nodes no longer exist
	
	# 墨迹飞溅效果
	if ink_splash1 and ink_splash2:
		var ink_tween = create_tween()
		ink_tween.parallel().tween_property(ink_splash1, "rotation", 0.5, 2.0)
		ink_tween.parallel().tween_property(ink_splash2, "rotation", -0.4, 2.0)
		ink_tween.set_loops()
		ink_tween.set_trans(Tween.TRANS_SINE)
		ink_tween.set_ease(Tween.EASE_IN_OUT)

func _start_capros_animation_variant(variant: int):
	# 根据选择启动不同的CAPROS动画方案
	match variant:
		1:
			_start_capros_glitch_appear()  # 故障艺术浮现
		2:
			_start_capros_ink_spread()     # 墨迹扩散
		3:
			_start_capros_scanline()       # 扫描线浮现
		4:
			_start_capros_particle()       # 粒子汇聚
		5:
			_start_capros_3d_flip()        # 3D翻转
		6:
			_start_capros_card_slide()     # 卡片式滑入
		_:
			_start_capros_glitch_appear()  # 默认故障艺术

func _start_capros_glitch_appear():
	# CAPROS图片故障浮现动画
	if main_title:
		# 初始状态：图片完全透明
		main_title.modulate.a = 0.0
		main_title.scale = Vector2(0.5, 0.5)
		main_title.rotation = 0.1
		
		# 第一阶段：快速闪烁出现
		var flash_tween = create_tween()
		flash_tween.tween_property(main_title, "modulate:a", 0.3, 0.1)
		flash_tween.tween_property(main_title, "modulate:a", 0.0, 0.1)
		flash_tween.tween_property(main_title, "modulate:a", 0.7, 0.1)
		flash_tween.tween_property(main_title, "modulate:a", 0.0, 0.1)
		flash_tween.tween_property(main_title, "modulate:a", 1.0, 0.2)
		
		# 第二阶段：缩放和旋转效果
		var scale_tween = create_tween()
		scale_tween.parallel().tween_property(main_title, "scale", Vector2(1.2, 1.2), 0.3)
		scale_tween.parallel().tween_property(main_title, "rotation", -0.05, 0.3)
		scale_tween.tween_property(main_title, "scale", Vector2(1.0, 1.0), 0.2)
		scale_tween.tween_property(main_title, "rotation", 0.0, 0.2)
		
		# 第三阶段：持续故障效果
		_start_capros_glitch_loop()

func _start_capros_glitch_loop():
	# CAPROS图片持续故障效果
	if main_title:
		var glitch_tween = create_tween()
		# 随机位置偏移
		var original_pos = main_title.position
		glitch_tween.tween_property(main_title, "position", original_pos + Vector2(2, 0), 0.05)
		glitch_tween.tween_property(main_title, "position", original_pos + Vector2(-1, 1), 0.05)
		glitch_tween.tween_property(main_title, "position", original_pos + Vector2(1, -1), 0.05)
		glitch_tween.tween_property(main_title, "position", original_pos, 0.05)
		
		# 随机透明度变化
		glitch_tween.parallel().tween_property(main_title, "modulate:a", 0.8, 0.1)
		glitch_tween.parallel().tween_property(main_title, "modulate:a", 1.0, 0.1)
		
		# 随机缩放
		glitch_tween.parallel().tween_property(main_title, "scale", Vector2(1.02, 1.02), 0.1)
		glitch_tween.parallel().tween_property(main_title, "scale", Vector2(1.0, 1.0), 0.1)
		
		glitch_tween.set_loops()
		glitch_tween.set_trans(Tween.TRANS_LINEAR)
		glitch_tween.set_ease(Tween.EASE_IN_OUT)

func _start_capros_ink_spread():
	# 方案2：墨迹扩散效果
	if main_title:
		main_title.modulate.a = 0.0
		main_title.scale = Vector2(0.1, 0.1)
		main_title.position = main_title.position + Vector2(300, 100)  # 从中心开始
		
		var ink_tween = create_tween()
		# 扩散效果
		ink_tween.parallel().tween_property(main_title, "scale", Vector2(1.3, 1.3), 1.5)
		ink_tween.parallel().tween_property(main_title, "modulate:a", 1.0, 1.5)
		ink_tween.parallel().tween_property(main_title, "position", main_title.position - Vector2(300, 100), 1.5)
		
		# 回弹效果
		ink_tween.tween_property(main_title, "scale", Vector2(1.0, 1.0), 0.3)
		ink_tween.set_trans(Tween.TRANS_ELASTIC)
		ink_tween.set_ease(Tween.EASE_OUT)

func _start_capros_scanline():
	# 方案3：扫描线浮现
	if main_title:
		main_title.modulate.a = 0.0
		main_title.scale = Vector2(1.0, 0.0)  # 从0高度开始
		
		var scan_tween = create_tween()
		# 扫描线效果
		scan_tween.tween_property(main_title, "scale", Vector2(1.0, 1.0), 1.0)
		scan_tween.parallel().tween_property(main_title, "modulate:a", 1.0, 1.0)
		scan_tween.set_trans(Tween.TRANS_QUART)
		scan_tween.set_ease(Tween.EASE_OUT)
		
		# 扫描线闪烁效果
		var flash_tween = create_tween()
		flash_tween.tween_delay(0.5)
		flash_tween.tween_property(main_title, "modulate:a", 0.7, 0.1)
		flash_tween.tween_property(main_title, "modulate:a", 1.0, 0.1)

func _start_capros_particle():
	# 方案4：粒子汇聚效果
	if main_title:
		main_title.modulate.a = 0.0
		main_title.scale = Vector2(0.2, 0.2)
		main_title.position = main_title.position + Vector2(200, -100)
		
		var particle_tween = create_tween()
		# 粒子汇聚
		particle_tween.parallel().tween_property(main_title, "position", main_title.position - Vector2(200, -100), 1.2)
		particle_tween.parallel().tween_property(main_title, "scale", Vector2(1.1, 1.1), 1.2)
		particle_tween.parallel().tween_property(main_title, "modulate:a", 1.0, 1.2)
		
		# 发光效果
		particle_tween.tween_property(main_title, "modulate", Color(1.2, 1.2, 1.5, 1.0), 0.2)
		particle_tween.tween_property(main_title, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
		particle_tween.tween_property(main_title, "scale", Vector2(1.0, 1.0), 0.3)
		particle_tween.set_trans(Tween.TRANS_QUART)
		particle_tween.set_ease(Tween.EASE_OUT)

func _start_capros_3d_flip():
	# 方案5：3D翻转效果
	if main_title:
		main_title.modulate.a = 0.0
		main_title.scale = Vector2(0.0, 1.0)  # 从侧面开始
		main_title.rotation = 1.57  # 90度旋转
		
		var flip_tween = create_tween()
		# 3D翻转
		flip_tween.parallel().tween_property(main_title, "rotation", 0.0, 0.8)
		flip_tween.parallel().tween_property(main_title, "scale", Vector2(1.0, 1.0), 0.8)
		flip_tween.parallel().tween_property(main_title, "modulate:a", 1.0, 0.8)
		
		# 阴影效果（通过透明度模拟）
		flip_tween.tween_property(main_title, "modulate", Color(0.8, 0.8, 0.8, 1.0), 0.1)
		flip_tween.tween_property(main_title, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
		flip_tween.set_trans(Tween.TRANS_QUART)
		flip_tween.set_ease(Tween.EASE_OUT)

func _start_capros_card_slide():
	# 方案6：卡片式从屏幕外滑入（纯平移）
	if main_title:
		print("开始CAPROS卡片滑入动画")
		print("MainTitle当前位置: ", main_title.position)
		print("MainTitle可见性: ", main_title.visible)
		print("MainTitle透明度: ", main_title.modulate.a)
		
		# 保存原始位置
		var original_pos = main_title.position
		print("原始位置: ", original_pos)
		
		# 设置初始状态：图片在屏幕左侧外
		main_title.position = Vector2(-800, original_pos.y)
		main_title.modulate.a = 0.0
		main_title.visible = true
		
		print("设置初始位置: ", main_title.position)
		print("设置初始透明度: ", main_title.modulate.a)
		
		# 等待一小段时间确保设置生效
		await get_tree().create_timer(0.1).timeout
		
		var card_tween = create_tween()
		# 纯平移滑入效果
		card_tween.parallel().tween_property(main_title, "position", original_pos, 1.5)
		card_tween.parallel().tween_property(main_title, "modulate:a", 1.0, 1.5)
		card_tween.set_trans(Tween.TRANS_QUART)
		card_tween.set_ease(Tween.EASE_OUT)
		
		print("动画已启动，目标位置: ", original_pos)
		
		# 等待动画完成
		await card_tween.finished
		print("CAPROS卡片滑入动画完成")
	else:
		print("错误：main_title节点未找到")
		# 如果找不到节点，至少让图片显示出来
		print("尝试直接显示图片...")
		if main_title:
			main_title.modulate.a = 1.0
			main_title.visible = true

func _start_simple_card_slide():
	# 简单直接的卡片滑入动画
	if main_title:
		print("开始简单卡片滑入动画")
		
		# 获取当前屏幕尺寸
		var screen_size = get_viewport().get_visible_rect().size
		print("屏幕尺寸: ", screen_size)
		
		# 设置初始位置：完全在屏幕左侧外
		var start_pos = Vector2(-screen_size.x, main_title.position.y)
		var end_pos = main_title.position
		
		print("起始位置: ", start_pos)
		print("结束位置: ", end_pos)
		
		# 立即设置初始状态
		main_title.position = start_pos
		main_title.modulate.a = 0.0
		main_title.visible = true
		
		# 创建动画
		var tween = create_tween()
		tween.parallel().tween_property(main_title, "position", end_pos, 2.0)
		tween.parallel().tween_property(main_title, "modulate:a", 1.0, 2.0)
		tween.set_trans(Tween.TRANS_QUART)
		tween.set_ease(Tween.EASE_OUT)
		
		print("简单卡片滑入动画已启动")
		
		# 等待动画完成
		await tween.finished
		print("简单卡片滑入动画完成")
	else:
		print("错误：main_title节点未找到")

func _start_triangle_animations():
	# 三角形动态效果
	if triangle1:
		_start_triangle_slide_animation(triangle1, Vector2(-200, 0), 0.0)
	if triangle2:
		_start_triangle_slide_animation(triangle2, Vector2(200, 0), 0.3)
	if triangle3:
		_start_triangle_slide_animation(triangle3, Vector2(0, -150), 0.6)

func _start_triangle_slide_animation(triangle: ColorRect, offset: Vector2, delay: float):
	# 单个三角形滑入动画（纯平移）
	var original_pos = triangle.position
	triangle.position = original_pos + offset
	triangle.modulate.a = 0.0
	
	# 延迟启动
	await get_tree().create_timer(delay).timeout
	
	var triangle_tween = create_tween()
	triangle_tween.parallel().tween_property(triangle, "position", original_pos, 1.0)
	triangle_tween.parallel().tween_property(triangle, "modulate:a", 1.0, 1.0)
	triangle_tween.set_trans(Tween.TRANS_QUART)
	triangle_tween.set_ease(Tween.EASE_OUT)

func _start_line_animations():
	# 线条动态效果
	if line1:
		_start_line_slide_animation(line1, Vector2(-300, 0), 0.2)
	if line2:
		_start_line_slide_animation(line2, Vector2(300, 0), 0.5)

func _start_line_slide_animation(line: ColorRect, offset: Vector2, delay: float):
	# 单个线条滑入动画（纯平移）
	var original_pos = line.position
	line.position = original_pos + offset
	line.modulate.a = 0.0
	
	# 延迟启动
	await get_tree().create_timer(delay).timeout
	
	var line_tween = create_tween()
	line_tween.parallel().tween_property(line, "position", original_pos, 0.8)
	line_tween.parallel().tween_property(line, "modulate:a", 1.0, 0.8)
	line_tween.set_trans(Tween.TRANS_QUART)
	line_tween.set_ease(Tween.EASE_OUT)

func _start_ink_background_animations():
	# 墨迹背景动态效果
	if ink_splash1:
		_start_ink_splash_animation(ink_splash1, Vector2(-100, -50), 0.0)
	if ink_splash2:
		_start_ink_splash_animation(ink_splash2, Vector2(100, 50), 0.4)

func _start_ink_splash_animation(ink_splash: ColorRect, offset: Vector2, delay: float):
	# 单个墨迹飞溅动画（纯平移）
	var original_pos = ink_splash.position
	ink_splash.position = original_pos + offset
	ink_splash.modulate.a = 0.0
	
	# 延迟启动
	await get_tree().create_timer(delay).timeout
	
	var ink_tween = create_tween()
	ink_tween.parallel().tween_property(ink_splash, "position", original_pos, 1.2)
	ink_tween.parallel().tween_property(ink_splash, "modulate:a", 1.0, 1.2)
	ink_tween.set_trans(Tween.TRANS_QUART)
	ink_tween.set_ease(Tween.EASE_OUT)

func _menu_fade_in_animation():
	# 菜单按钮渐入动画
	menu_container.visible = true
	var tween = create_tween()
	tween.parallel().tween_property(menu_container, "modulate:a", 1.0, 0.8)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

func _show_main_menu_animation():
	"""显示主菜单动画"""
	print("显示主菜单动画...")
	
	# 检查动画所需的节点是否存在
	if not geometric_elements:
		print("ERROR: GeometricElements node not found!")
		return
	
	# 启动主菜单动画
	_start_p3r_intro_animation()

func _on_start_pressed():
	print("开始游戏")
	_start_button_click_effect(start_button)
	
	# 等待按钮动画完成
	await get_tree().create_timer(0.5).timeout
	
	# 先显示主菜单动画，然后开始序章
	_show_main_menu_animation()
	await get_tree().create_timer(2.0).timeout
	
	# 开始序章
	_start_prologue()

func _on_continue_pressed():
	print("继续游戏")
	_start_button_click_effect(continue_button)

func _on_settings_pressed():
	print("打开设置")
	_start_button_click_effect(settings_button)

func _on_exit_pressed():
	_start_button_click_effect(exit_button)
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

func _on_button_hover(button: Button):
	# 按钮悬停效果
	if button:
		print("Button hover: ", button.text)
		var tween = create_tween()
		tween.parallel().tween_property(button, "scale", Vector2(1.1, 1.1), 0.2)
		tween.parallel().tween_property(button, "modulate", Color(1.2, 1.2, 1.5, 1.0), 0.2)
		tween.set_trans(Tween.TRANS_QUART)
		tween.set_ease(Tween.EASE_OUT)
		
		# 添加发光效果
		_start_button_glow(button)

func _on_button_unhover(button: Button):
	# 按钮取消悬停效果
	if button:
		print("Button unhover: ", button.text)
		var tween = create_tween()
		tween.parallel().tween_property(button, "scale", Vector2(1.0, 1.0), 0.2)
		tween.parallel().tween_property(button, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
		tween.set_trans(Tween.TRANS_QUART)
		tween.set_ease(Tween.EASE_OUT)
		
		# 停止发光效果
		_stop_button_glow(button)

func _start_button_glow(button: Button):
	# 按钮发光效果
	if button:
		var glow_tween = create_tween()
		glow_tween.tween_property(button, "modulate", Color(1.5, 1.5, 2.0, 1.0), 0.5)
		glow_tween.tween_property(button, "modulate", Color(1.2, 1.2, 1.5, 1.0), 0.5)
		glow_tween.set_loops()
		glow_tween.set_trans(Tween.TRANS_SINE)
		glow_tween.set_ease(Tween.EASE_IN_OUT)
		
		# 存储tween引用以便停止
		button.set_meta("glow_tween", glow_tween)

func _stop_button_glow(button: Button):
	# 停止按钮发光效果
	if button and button.has_meta("glow_tween"):
		var glow_tween = button.get_meta("glow_tween")
		if glow_tween:
			glow_tween.kill()
		button.remove_meta("glow_tween")

func _start_button_click_effect(button: Button):
	# 按钮点击效果
	if button:
		print("Button clicked: ", button.text)
		
		# 停止之前的发光效果
		_stop_button_glow(button)
		
		# 点击动画：缩放 + 颜色变化
		var click_tween = create_tween()
		click_tween.parallel().tween_property(button, "scale", Vector2(0.95, 0.95), 0.1)
		click_tween.parallel().tween_property(button, "modulate", Color(2.0, 1.0, 1.0, 1.0), 0.1)
		click_tween.set_trans(Tween.TRANS_QUART)
		click_tween.set_ease(Tween.EASE_OUT)
		
		# 等待点击动画完成
		await click_tween.finished
		
		# 恢复动画
		var restore_tween = create_tween()
		restore_tween.parallel().tween_property(button, "scale", Vector2(1.0, 1.0), 0.2)
		restore_tween.parallel().tween_property(button, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
		restore_tween.set_trans(Tween.TRANS_QUART)
		restore_tween.set_ease(Tween.EASE_OUT)
		
		# 添加点击后的脉冲效果
		_start_button_pulse(button)

func _start_button_pulse(button: Button):
	# 按钮脉冲效果
	if button:
		var pulse_tween = create_tween()
		pulse_tween.tween_property(button, "modulate", Color(1.3, 1.3, 1.8, 1.0), 0.3)
		pulse_tween.tween_property(button, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)
		pulse_tween.set_trans(Tween.TRANS_SINE)
		pulse_tween.set_ease(Tween.EASE_IN_OUT)

func _start_prologue():
	"""开始序章"""
	print("启动序章...")
	
	# 方案：末世氛围营造
	# 1. 屏幕逐渐变暗
	var fade_tween = create_tween()
	fade_tween.tween_property(background, "modulate", Color(0.1, 0.1, 0.1, 1.0), 2.0)
	fade_tween.set_trans(Tween.TRANS_QUART)
	fade_tween.set_ease(Tween.EASE_IN)
	
	# 2. 雨声增强
	if bgm_player:
		var volume_tween = create_tween()
		volume_tween.tween_property(bgm_player, "volume_db", -20.0, 2.0)
	
	# 3. 等待氛围营造完成
	await fade_tween.finished
	
	# 4. 加载序章UI场景
	_load_prologue_ui()

func _load_prologue_ui():
	"""加载序章UI场景"""
	print("加载序章UI场景...")
	
	# 加载简化版序章UI场景
	var prologue_ui_scene = preload("res://game/scenes/ui/SimplePrologueUI.tscn")
	var prologue_ui_instance = prologue_ui_scene.instantiate()
	
	# 添加到场景树
	add_child(prologue_ui_instance)
	
	# 连接信号
	prologue_ui_instance.prologue_finished.connect(_on_prologue_finished)
	
	print("序章UI加载完成")

func _load_prologue_scene():
	"""加载序章场景（备用方法）"""
	print("加载序章场景...")
	
	# 创建序章脚本
	var prologue_script = preload("res://game/scripts/story/DialogicPrologue.gd").new()
	add_child(prologue_script)
	
	# 连接信号
	prologue_script.prologue_finished.connect(_on_prologue_finished)
	
	# 开始序章
	prologue_script.start_prologue()

func _on_prologue_finished():
	"""序章完成"""
	print("序章完成，进入主游戏...")
	
	# 这里可以加载主游戏场景
	# 或者进入卡牌战斗教程
	# TODO: 实现卡牌战斗系统后，加载相应的场景
	print("序章完成，准备进入卡牌战斗系统...")
	
	# 暂时显示一个简单的消息
	var message = "序章完成！\n\n卡牌战斗系统正在开发中...\n\n按ESC键返回主菜单"
	print(message)

# Input handling removed - press button node no longer exists
