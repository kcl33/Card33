extends CanvasLayer

@onready var bg := $BG
@onready var contour := $BG/Contour
@onready var stripes := $BG/Stripes
@onready var title := $Title
@onready var menu := $Menu

var theme_profile: PunkThemeProfile
var motion: UIMotion
var first_clicked := false

func _ready():
	# 准备主题与动效
	theme_profile = PunkThemeProfile.new()
	motion = UIMotion.new()
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
	var i := 0
	for child in menu.get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = false
	for child in menu.get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = true
			motion.show_with_motion(child, float(i) * theme_profile.reveal_step_delay)
			i += 1


