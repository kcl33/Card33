extends Control

@export var text: String = "TITLE"
@export var skew_degrees: float = 12.0
@export var bg_color: Color = Color(0.93, 0, 0.35, 1)
@export var font_color: Color = Color(1,1,1,1)

func _ready():
	rotation_degrees = skew_degrees
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg_color
	sb.corner_radius_top_left = 0
	sb.corner_radius_top_right = 0
	sb.corner_radius_bottom_left = 0
	sb.corner_radius_bottom_right = 0
	# 使用 Label 背板模拟肩标块
	var panel := StyleBoxFlat.new()
	panel.bg_color = bg_color
	add_theme_stylebox_override("panel", panel)
	$Label.text = text
	$Label.add_theme_color_override("font_color", font_color)


