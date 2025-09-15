extends Control

@export var fill_color: Color = Color(0,0,0,0.6)
@export var border_color: Color = Color(0.93, 0, 0.35, 1)
@export var border_width: float = 2.0
@export var skew_degrees: float = -8.0

func _ready():
	rotation_degrees = skew_degrees
	var sb := StyleBoxFlat.new()
	sb.bg_color = fill_color
	sb.border_color = border_color
	sb.border_width_left = border_width
	sb.border_width_top = border_width
	sb.border_width_right = border_width
	sb.border_width_bottom = border_width
	$Panel.add_theme_stylebox_override("panel", sb)
	$Label.add_theme_color_override("font_color", Color(1,1,1,1))


