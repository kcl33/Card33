extends Control

@export var skew_degrees_left: float = 12.0
@export var skew_degrees_right: float = 0.0
@export var border_width: float = 3.0
@export var fill_color: Color = Color(0,0,0,0.6)
@export var border_color: Color = Color(0.93, 0, 0.35, 1)

func _ready():
	# 填充
	var fill := $Fill
	var sb := StyleBoxFlat.new()
	sb.bg_color = fill_color
	sb.border_color = border_color
	sb.border_width_left = border_width
	sb.border_width_top = border_width
	sb.border_width_right = border_width
	sb.border_width_bottom = border_width
	sb.corner_radius_top_left = 0
	sb.corner_radius_top_right = 0
	sb.corner_radius_bottom_left = 0
	sb.corner_radius_bottom_right = 0
	fill.add_theme_stylebox_override("panel", sb)

	# 斜向条纹遮罩
	var stripes_mat := ShaderMaterial.new()
	stripes_mat.shader = load("res://res/shaders/Stripes.gdshader")
	$StripesMask.material = stripes_mat

	# 应用倾斜（整体旋转细微）
	rotation_degrees = clamp(skew_degrees_left - skew_degrees_right, -20.0, 20.0)


