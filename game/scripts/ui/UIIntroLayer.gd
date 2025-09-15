extends CanvasLayer

@onready var bg := $BG
@onready var contour := $BG/Contour
@onready var stripes := $BG/Stripes
@onready var dots := $BG/Dots
@onready var title := $Title
@onready var menu := $Menu
@onready var rain := $Rain

const PunkThemeProfileRes = preload("res://game/scripts/ui/PunkThemeProfile.gd")
const UIMotionRes = preload("res://game/scripts/ui/UIMotion.gd")
const GridRes = preload("res://game/scripts/ui/UIGridContainer.gd")

var theme_profile
var motion
var first_clicked := false

func _ready():
	# 准备主题与动效
	theme_profile = PunkThemeProfileRes.new()
	motion = UIMotionRes.new()
	add_child(motion)
	motion.theme_profile = theme_profile
	# 确保在最顶层
	if self is CanvasLayer:
		(self as CanvasLayer).layer = 100

	# 应用背景材质
	var grad_mat := ShaderMaterial.new()
	grad_mat.shader = load("res://res/shaders/ContourGradient.gdshader")
	grad_mat.set_shader_parameter("color_bg", Color(0,0,0,1))
	grad_mat.set_shader_parameter("color_fg", theme_profile.color_magenta)
	grad_mat.set_shader_parameter("line_width", theme_profile.contour_line_width)
	grad_mat.set_shader_parameter("line_spacing", theme_profile.contour_line_spacing)
	grad_mat.set_shader_parameter("flow_speed", theme_profile.contour_flow_speed)
	contour.material = grad_mat

	var stripe_mat := ShaderMaterial.new()
	stripe_mat.shader = load("res://res/shaders/Stripes.gdshader")
	stripe_mat.set_shader_parameter("angle_degrees", theme_profile.stripes_angle_degrees)
	stripe_mat.set_shader_parameter("speed", theme_profile.stripes_speed)
	stripe_mat.set_shader_parameter("contrast", theme_profile.stripes_contrast)
	stripe_mat.set_shader_parameter("color_a", theme_profile.color_black)
	stripe_mat.set_shader_parameter("color_b", theme_profile.color_magenta)
	stripes.material = stripe_mat

	# 灰点与圆球层
	var dots_mat := ShaderMaterial.new()
	dots_mat.shader = load("res://res/shaders/HalftoneDotsAndCircles.gdshader")
	dots.material = dots_mat

	# 雨滴前景
	var rain_mat := ShaderMaterial.new()
	rain_mat.shader = load("res://res/shaders/RainDrops.gdshader")
	rain.material = rain_mat
	rain.visible = false

	# 初始标题倾斜
	title.rotation_degrees = theme_profile.title_skew_degrees
	title.add_theme_color_override("font_color", theme_profile.color_white)
	# 标题肩标扫光材质
	var sweep := ShaderMaterial.new()
	sweep.shader = load("res://res/shaders/SweepFlash.gdshader")
	title.material = sweep

	# 引导点击提示（可后续加入闪光/灰点）
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if first_clicked:
		return
	if event is InputEventMouseButton and event.pressed:
		first_clicked = true
		_reveal_sequence()

func _reveal_sequence():
	# 标题外抛->弹入
	motion.title_blast(title)
	await get_tree().create_timer(0.46).timeout
	# 显示菜单并阶梯入场
	menu.visible = true
	# 使用可视区域安置主面板与菜单，避免未初始化尺寸导致错位
	var vp_size := get_viewport().get_visible_rect().size
	var rect_scene: PackedScene = load("res://game/scenes/ui/UIRectAccent.tscn")
	var rect := rect_scene.instantiate()
	add_child(rect)
	var panel_size := Vector2(vp_size.x * 0.44, vp_size.y * 0.38)
	var panel_pos := Vector2(vp_size.x * 0.28, vp_size.y * 0.36)
	rect.position = panel_pos
	rect.size = panel_size
	menu.reparent(rect)
	menu.position = Vector2(24, 24)
	menu.size = panel_size - Vector2(48, 48)

	# 右下状态卡片
	var status_scene: PackedScene = load("res://game/scenes/ui/StatusCard.tscn")
	var status := status_scene.instantiate()
	add_child(status)
	status.position = Vector2(get_viewport().size.x - 320, get_viewport().size.y - 160)
	# 替换按钮为朋克按钮皮肤
	for i in range(menu.get_child_count()):
		var child = menu.get_child(i)
		if child is Button:
			var punk_scene: PackedScene = load("res://game/scenes/ui/UIButtonPunk.tscn")
			var punk_btn: Button = punk_scene.instantiate() as Button
			punk_btn.text = (child as Button).text
			menu.remove_child(child)
			child.queue_free()
			menu.add_child(punk_btn)
	var i := 0
	for child in menu.get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = false
	for child in menu.get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = true
			motion.show_with_motion(child, float(i) * theme_profile.reveal_step_delay)
			i += 1

	# 启用前景雨滴
	rain.visible = true
