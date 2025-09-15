extends Button

var theme_profile_res = preload("res://game/scripts/ui/PunkThemeProfile.gd")
var theme_profile = theme_profile_res.new()

func _ready():
	# 棱角分明描边与倾斜
	rotation_degrees = theme_profile.title_skew_degrees
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0,0,0,0.0)
	sb.border_color = theme_profile.color_magenta
	sb.border_width_left = 3
	sb.border_width_top = 3
	sb.border_width_right = 3
	sb.border_width_bottom = 3
	sb.corner_radius_top_left = 0
	sb.corner_radius_top_right = 0
	sb.corner_radius_bottom_left = 0
	sb.corner_radius_bottom_right = 0
	add_theme_stylebox_override("normal", sb)
	add_theme_color_override("font_color", theme_profile.color_white)
	add_theme_font_size_override("font_size", 24)

func _gui_input(event):
	if event is InputEventMouseMotion:
		scale = Vector2.ONE * theme_profile.font_scale_hover
	elif event is InputEventMouseButton and event.pressed:
		scale = Vector2(1.08, 1.08)
		create_tween().tween_property(self, "scale", Vector2.ONE, 0.15)


