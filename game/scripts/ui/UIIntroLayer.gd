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
	# 使用格栅布局安置主面板和菜单
	var grid := GridRes.new()
	add_child(grid)
	grid.columns = 12
	grid.gutter = 16
	# 主面板容器（用 UIRectAccent 包裹菜单）
	var rect_scene: PackedScene = load("res://game/scenes/ui/UIRectAccent.tscn")
	var rect := rect_scene.instantiate()
	add_child(rect)
	grid.layout_child(rect, 3, 7, 260, 320)
	menu.reparent(rect)
	menu.position = Vector2(24, 24)
	menu.size = rect.size - Vector2(48, 48)
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
