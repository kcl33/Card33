extends CanvasLayer

@onready var background := $Background
@onready var background_effect := $BackgroundEffect
@onready var geometric_elements := $GeometricElements
@onready var triangle1 := $GeometricElements/Triangle1
@onready var triangle2 := $GeometricElements/Triangle2
@onready var triangle3 := $GeometricElements/Triangle3
@onready var line1 := $GeometricElements/Line1
@onready var line2 := $GeometricElements/Line2
@onready var stripe_masks := $StripeMasks
@onready var stripe1 := $StripeMasks/Stripe1
@onready var stripe2 := $StripeMasks/Stripe2
@onready var stripe3 := $StripeMasks/Stripe3
@onready var stripe4 := $StripeMasks/Stripe4
@onready var title_container := $TitleContainer
@onready var title_background := $TitleContainer/TitleBackground
@onready var ink_splash1 := $TitleContainer/InkSplash1
@onready var ink_splash2 := $TitleContainer/InkSplash2
@onready var glitch_line1 := $TitleContainer/GlitchLine1
@onready var glitch_line2 := $TitleContainer/GlitchLine2
@onready var main_title := $TitleContainer/MainTitle
@onready var sub_title := $TitleContainer/SubTitle
@onready var english_title := $TitleContainer/EnglishTitle
@onready var press_button_prompt := $PressButtonPrompt
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

	# 设置背景效果
	_setup_background_effects()
	
	# 设置菜单按钮
	_setup_menu_buttons()
	
	# 初始状态：所有元素隐藏
	if title_container:
		title_container.modulate.a = 0.0
	if menu_container:
		menu_container.modulate.a = 0.0
	if geometric_elements:
		geometric_elements.modulate.a = 0.0
	if stripe_masks:
		stripe_masks.modulate.a = 0.0
	
	# 开始P3R风格的开场动画
	await get_tree().create_timer(0.5).timeout
	_start_p3r_intro_animation()
	
	# 连接输入事件
	set_process_input(true)

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

func _setup_menu_buttons():
	# 连接按钮信号
	print("Setting up menu buttons...")
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
		print("Start button connected")
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)
		print("Continue button connected")
	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)
		print("Settings button connected")
	if exit_button:
		exit_button.pressed.connect(_on_exit_pressed)
		print("Exit button connected")

func _start_p3r_intro_animation():
	# 第一阶段：条纹蒙版划过
	_stripe_masks_animation()
	
	# 等待条纹动画完成
	await get_tree().create_timer(2.0).timeout
	
	# 第二阶段：几何元素淡入
	_geometric_elements_animation()
	
	# 等待几何元素动画完成
	await get_tree().create_timer(1.0).timeout
	
	# 第三阶段：标题渐入动画
	_title_fade_in_animation()
	
	await get_tree().create_timer(1.0).timeout
	
	# 第四阶段：PRESS ANY BUTTON提示
	_start_press_button_animation()
	
	await get_tree().create_timer(1.0).timeout
	
	# 第五阶段：菜单按钮渐入
	_menu_fade_in_animation()

func _stripe_masks_animation():
	# 条纹蒙版在标题区域内划过动画
	if stripe_masks:
		stripe_masks.modulate.a = 1.0
		
		# 设置初始位置（标题区域左侧外）
		var stripes = [stripe1, stripe2, stripe3, stripe4]
		for i in range(stripes.size()):
			if stripes[i]:
				stripes[i].position.x = -150 - (i * 50)
		
		# 为每个条纹创建独立的动画
		for i in range(stripes.size()):
			if stripes[i]:
				_start_delayed_stripe_animation(stripes[i], i * 0.3, 1.0 + (i * 0.1))

func _start_delayed_stripe_animation(stripe: ColorRect, delay: float, duration: float):
	# 创建延迟定时器
	var timer = Timer.new()
	timer.wait_time = delay
	timer.one_shot = true
	add_child(timer)
	timer.start()
	
	# 等待延迟时间
	await timer.timeout
	timer.queue_free()
	
	# 开始条纹动画（只在标题区域内移动）
	var tween = create_tween()
	tween.tween_property(stripe, "position:x", 400, duration)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN_OUT)

func _geometric_elements_animation():
	# 几何元素淡入动画
	var tween = create_tween()
	tween.parallel().tween_property(geometric_elements, "modulate:a", 1.0, 1.5)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

func _title_fade_in_animation():
	# 标题渐入动画
	var tween = create_tween()
	tween.parallel().tween_property(title_container, "modulate:a", 1.0, 1.0)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	
	# 启动故障效果动画
	_start_glitch_effects()
	
	# 启动CAPROS图片浮现动画（可选择不同方案）
	_start_capros_animation_variant(1)  # 1=故障艺术, 2=墨迹扩散, 3=扫描线, 4=粒子汇聚, 5=3D翻转

func _start_press_button_animation():
	# PRESS ANY BUTTON提示动画
	if press_button_prompt:
		press_button_prompt.visible = true
		press_button_prompt.modulate.a = 0.0
		
		# 淡入动画
		var tween = create_tween()
		tween.tween_property(press_button_prompt, "modulate:a", 1.0, 0.8)
		tween.set_trans(Tween.TRANS_QUART)
		tween.set_ease(Tween.EASE_OUT)
		
		# 等待淡入完成后开始闪烁
		await tween.finished
		_start_press_button_flicker()

func _start_press_button_flicker():
	# PRESS ANY BUTTON闪烁效果
	if press_button_prompt:
		var flicker_tween = create_tween()
		flicker_tween.tween_property(press_button_prompt, "modulate:a", 0.3, 0.8)
		flicker_tween.tween_property(press_button_prompt, "modulate:a", 1.0, 0.8)
		flicker_tween.set_loops()
		flicker_tween.set_trans(Tween.TRANS_SINE)
		flicker_tween.set_ease(Tween.EASE_IN_OUT)

func _start_glitch_effects():
	# 故障效果动画
	if glitch_line1 and glitch_line2:
		# 故障线条闪烁效果
		var glitch_tween = create_tween()
		glitch_tween.parallel().tween_property(glitch_line1, "modulate:a", 0.0, 0.1)
		glitch_tween.parallel().tween_property(glitch_line2, "modulate:a", 0.0, 0.1)
		glitch_tween.tween_property(glitch_line1, "modulate:a", 0.8, 0.1)
		glitch_tween.tween_property(glitch_line2, "modulate:a", 0.6, 0.1)
		glitch_tween.set_loops()
		glitch_tween.set_trans(Tween.TRANS_LINEAR)
		glitch_tween.set_ease(Tween.EASE_IN_OUT)
	
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

func _menu_fade_in_animation():
	# 菜单按钮渐入动画
	menu_container.visible = true
	var tween = create_tween()
	tween.parallel().tween_property(menu_container, "modulate:a", 1.0, 0.8)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

func _on_start_pressed():
	print("开始游戏")

func _on_continue_pressed():
	print("继续游戏")

func _on_settings_pressed():
	print("打开设置")

func _on_exit_pressed():
	get_tree().quit()

func _input(event):
	# 处理PRESS ANY BUTTON的点击
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if press_button_prompt and press_button_prompt.visible:
			_on_press_any_button_clicked()
	elif event is InputEventKey and event.pressed:
		if press_button_prompt and press_button_prompt.visible:
			_on_press_any_button_clicked()

func _on_press_any_button_clicked():
	# 隐藏PRESS ANY BUTTON提示
	if press_button_prompt:
		press_button_prompt.visible = false
	
	# 显示菜单按钮
	_menu_fade_in_animation()
