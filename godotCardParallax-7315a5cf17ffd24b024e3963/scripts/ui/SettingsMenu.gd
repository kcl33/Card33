class_name SettingsMenu
extends Control

@onready var music_volume_slider = $Panel/SettingsContainer/MusicVolumeSlider
@onready var sfx_volume_slider = $Panel/SettingsContainer/SFXVolumeSlider
@onready var fullscreen_checkbox = $Panel/SettingsContainer/FullscreenCheckbox
@onready var language_option_button = $Panel/SettingsContainer/LanguageOptionButton
@onready var cancel_button = $Panel/ButtonContainer/CancelButton
@onready var apply_button = $Panel/ButtonContainer/ApplyButton

signal settings_applied

func _ready():
	# 连接信号
	cancel_button.connect("pressed", self, "_on_cancel_pressed")
	apply_button.connect("pressed", self, "_on_apply_pressed")
	
	# 初始化语言选项
	language_option_button.add_item("中文", 0)
	language_option_button.add_item("English", 1)
	
	# 加载当前设置
	load_current_settings()

func load_current_settings():
	# 这里应该从设置管理器加载当前设置
	music_volume_slider.value = 100
	sfx_volume_slider.value = 100
	fullscreen_checkbox.pressed = false
	language_option_button.selected = 0

func show_menu():
	show()

func hide_menu():
	hide()

func _on_cancel_pressed():
	hide_menu()

func _on_apply_pressed():
	# 应用设置
	apply_settings()
	hide_menu()
	emit_signal("settings_applied")

func apply_settings():
	# 这里应该将设置应用到设置管理器
	var music_volume = music_volume_slider.value / 100.0
	var sfx_volume = sfx_volume_slider.value / 100.0
	var fullscreen = fullscreen_checkbox.pressed
	var language_index = language_option_button.selected
	var language = "zh" if language_index == 0 else "en"
	
	print("应用设置: 音乐音量=%f, 音效音量=%f, 全屏=%s, 语言=%s" % 
	      [music_volume, sfx_volume, fullscreen, language])