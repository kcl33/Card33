class_name SettingsManager
extends Node

signal settings_changed

var music_volume: float = 1.0
var sfx_volume: float = 1.0
var fullscreen: bool = false
var language: String = "zh"

func _init():
	load_settings()

func load_settings():
	# 从存档管理器加载设置
	# 这里应该与SaveManager集成
	pass

func save_settings():
	# 保存设置到存档管理器
	# 这里应该与SaveManager集成
	emit_signal("settings_changed")

func set_music_volume(volume: float):
	music_volume = clamp(volume, 0.0, 1.0)
	save_settings()

func set_sfx_volume(volume: float):
	sfx_volume = clamp(volume, 0.0, 1.0)
	save_settings()

func set_fullscreen(enabled: bool):
	fullscreen = enabled
	save_settings()
	
	# 应用全屏设置
	if OS.has_feature("standalone"):
		OS.window_fullscreen = fullscreen

func set_language(lang: String):
	language = lang
	save_settings()