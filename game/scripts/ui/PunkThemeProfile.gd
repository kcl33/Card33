extends Resource
class_name PunkThemeProfile

@export_group("Colors")
@export var color_magenta: Color = Color(0.9, 0.0, 0.35, 1.0) # 品红（主色，约30%）
@export var color_black: Color = Color(0, 0, 0, 1.0)          # 黑（约65%）
@export var color_white: Color = Color(1, 1, 1, 1.0)          # 白（约5%）
@export var color_gray_dot: Color = Color(0.6, 0.6, 0.6, 1.0)  # 灰色小波点

@export_group("Typography")
@export var title_skew_degrees: float = 10.0
@export var title_outline_width: float = 4.0
@export var label_outline_width: float = 3.0
@export var font_scale_hover: float = 1.04

@export_group("Stripes")
@export var stripes_angle_degrees: float = 12.0
@export var stripes_speed: float = 0.25
@export var stripes_contrast: float = 1.0

@export_group("Contour Gradient")
@export var contour_line_width: float = 0.006
@export var contour_line_spacing: float = 0.06
@export var contour_flow_speed: float = 0.02

@export_group("Reveal Motion")
@export var reveal_step_delay: float = 0.08
@export var reveal_scale_peak: float = 1.12
@export var reveal_skew_degrees: float = 10.0
@export var glow_flash_strength: float = 0.6


