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
@onready var main_title := $TitleContainer/MainTitle
@onready var sub_title := $TitleContainer/SubTitle
@onready var english_title := $TitleContainer/EnglishTitle
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
	
	# 第三阶段：标题渐入动画（带闪烁效果）
	_title_fade_in_animation()
	
	await get_tree().create_timer(1.0).timeout
	
	# 第四阶段：菜单按钮渐入
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
