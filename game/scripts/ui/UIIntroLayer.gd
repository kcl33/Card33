extends CanvasLayer

@onready var background := $Background
@onready var background_effect := $BackgroundEffect
@onready var geometric_elements := $GeometricElements
@onready var triangle1 := $GeometricElements/Triangle1
@onready var triangle2 := $GeometricElements/Triangle2
@onready var triangle3 := $GeometricElements/Triangle3
@onready var line1 := $GeometricElements/Line1
@onready var line2 := $GeometricElements/Line2
@onready var title_container := $TitleContainer
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

	# 设置背景效果
	_setup_background_effects()
	
	# 设置菜单按钮
	_setup_menu_buttons()
	
	# 初始状态：所有元素隐藏
	title_container.modulate.a = 0.0
	menu_container.modulate.a = 0.0
	geometric_elements.modulate.a = 0.0
	
	# 开始P3R风格的开场动画
	await get_tree().create_timer(0.5).timeout
	_start_p3r_intro_animation()

func _setup_background_effects():
	# 设置背景shader参数
	if background_effect and background_effect.material:
		var material = background_effect.material as ShaderMaterial
		material.set_shader_parameter("time_scale", 1.0)
		material.set_shader_parameter("wave_amplitude", 0.1)
		material.set_shader_parameter("wave_frequency", 2.0)
		material.set_shader_parameter("gradient_speed", 1.0)
		material.set_shader_parameter("noise_scale", 5.0)
		material.set_shader_parameter("noise_strength", 0.3)

func _setup_menu_buttons():
	# 连接按钮信号
	start_button.pressed.connect(_on_start_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _start_p3r_intro_animation():
	# 第一阶段：几何元素淡入
	_geometric_elements_animation()
	
	# 等待几何元素动画完成
	await get_tree().create_timer(1.5).timeout
	
	# 第二阶段：标题渐入动画
	_title_fade_in_animation()
	
	await get_tree().create_timer(1.0).timeout
	
	# 第三阶段：菜单按钮渐入
	_menu_fade_in_animation()

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
