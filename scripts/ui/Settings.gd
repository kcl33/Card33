extends Control

# 设置界面控制脚本

# UI元素引用
@onready var master_volume_slider = $MainContainer/SettingsContainer/AudioSection/MasterVolumeContainer/MasterVolumeSlider
@onready var master_volume_value = $MainContainer/SettingsContainer/AudioSection/MasterVolumeContainer/MasterVolumeValue
@onready var music_volume_slider = $MainContainer/SettingsContainer/AudioSection/MusicVolumeContainer/MusicVolumeSlider
@onready var music_volume_value = $MainContainer/SettingsContainer/AudioSection/MusicVolumeContainer/MusicVolumeValue
@onready var sfx_volume_slider = $MainContainer/SettingsContainer/AudioSection/SFXVolumeContainer/SFXVolumeSlider
@onready var sfx_volume_value = $MainContainer/SettingsContainer/AudioSection/SFXVolumeContainer/SFXVolumeValue

@onready var fullscreen_checkbox = $MainContainer/SettingsContainer/GraphicsSection/FullscreenContainer/FullscreenCheckBox
@onready var vsync_checkbox = $MainContainer/SettingsContainer/GraphicsSection/VSyncContainer/VSyncCheckBox

@onready var back_button = $MainContainer/SettingsContainer/ButtonContainer/BackButton
@onready var apply_button = $MainContainer/SettingsContainer/ButtonContainer/ApplyButton

# 设置数据
var settings_data = {
	"master_volume": 100.0,
	"music_volume": 80.0,
	"sfx_volume": 90.0,
	"fullscreen": false,
	"vsync": true
}

func _ready():
	# 连接信号
	setup_connections()
	
	# 加载设置
	load_settings()
	
	# 更新UI
	update_ui()

func setup_connections():
	# 音量滑块
	master_volume_slider.connect("value_changed", _on_master_volume_changed)
	music_volume_slider.connect("value_changed", _on_music_volume_changed)
	sfx_volume_slider.connect("value_changed", _on_sfx_volume_changed)
	
	# 复选框
	fullscreen_checkbox.connect("toggled", _on_fullscreen_toggled)
	vsync_checkbox.connect("toggled", _on_vsync_toggled)
	
	# 按钮
	back_button.connect("pressed", _on_back_pressed)
	apply_button.connect("pressed", _on_apply_pressed)

func load_settings():
	# 从配置文件加载设置
	var config_file = ConfigFile.new()
	var err = config_file.load("user://settings.cfg")
	
	if err == OK:
		settings_data.master_volume = config_file.get_value("audio", "master_volume", 100.0)
		settings_data.music_volume = config_file.get_value("audio", "music_volume", 80.0)
		settings_data.sfx_volume = config_file.get_value("audio", "sfx_volume", 90.0)
		settings_data.fullscreen = config_file.get_value("graphics", "fullscreen", false)
		settings_data.vsync = config_file.get_value("graphics", "vsync", true)

func save_settings():
	# 保存设置到配置文件
	var config_file = ConfigFile.new()
	
	config_file.set_value("audio", "master_volume", settings_data.master_volume)
	config_file.set_value("audio", "music_volume", settings_data.music_volume)
	config_file.set_value("audio", "sfx_volume", settings_data.sfx_volume)
	config_file.set_value("graphics", "fullscreen", settings_data.fullscreen)
	config_file.set_value("graphics", "vsync", settings_data.vsync)
	
	config_file.save("user://settings.cfg")

func update_ui():
	# 更新UI元素显示
	master_volume_slider.value = settings_data.master_volume
	master_volume_value.text = str(int(settings_data.master_volume)) + "%"
	
	music_volume_slider.value = settings_data.music_volume
	music_volume_value.text = str(int(settings_data.music_volume)) + "%"
	
	sfx_volume_slider.value = settings_data.sfx_volume
	sfx_volume_value.text = str(int(settings_data.sfx_volume)) + "%"
	
	fullscreen_checkbox.button_pressed = settings_data.fullscreen
	vsync_checkbox.button_pressed = settings_data.vsync

func apply_settings():
	# 应用设置到游戏
	# 音频设置
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(settings_data.master_volume / 100.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(settings_data.music_volume / 100.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(settings_data.sfx_volume / 100.0))
	
	# 图形设置
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN and settings_data.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN and not settings_data.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if settings_data.vsync else DisplayServer.VSYNC_DISABLED)

# 信号处理函数
func _on_master_volume_changed(value):
	settings_data.master_volume = value
	master_volume_value.text = str(int(value)) + "%"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value / 100.0))

func _on_music_volume_changed(value):
	settings_data.music_volume = value
	music_volume_value.text = str(int(value)) + "%"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value / 100.0))

func _on_sfx_volume_changed(value):
	settings_data.sfx_volume = value
	sfx_volume_value.text = str(int(value)) + "%"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value / 100.0))

func _on_fullscreen_toggled(pressed):
	settings_data.fullscreen = pressed

func _on_vsync_toggled(pressed):
	settings_data.vsync = pressed

func _on_back_pressed():
	# 返回主菜单
	get_tree().change_scene_to_file("res://Main.tscn")

func _on_apply_pressed():
	# 应用设置
	apply_settings()
	save_settings()
	print("设置已保存并应用")
