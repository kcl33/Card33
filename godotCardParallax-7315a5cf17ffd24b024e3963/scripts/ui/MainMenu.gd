class_name MainMenu
extends Control

@onready var title_label = $Title
@onready var start_button = $MenuContainer/StartButton
@onready var settings_button = $MenuContainer/SettingsButton
@onready var quit_button = $MenuContainer/QuitButton

signal start_game_requested
signal settings_requested
signal quit_requested

func _ready():
	# 连接按钮信号
	start_button.connect("pressed", self, "_on_start_pressed")
	settings_button.connect("pressed", self, "_on_settings_pressed")
	quit_button.connect("pressed", self, "_on_quit_pressed")
	
	# 动画显示标题
	animate_title()

func animate_title():
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(title_label, "percent_visible", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(title_label, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_start_pressed():
	emit_signal("start_game_requested")

func _on_settings_pressed():
	emit_signal("settings_requested")

func _on_quit_pressed():
	emit_signal("quit_requested")