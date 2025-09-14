class_name GameMenu
extends Control

@onready var resume_button = $MenuPanel/MenuContainer/ResumeButton
@onready var settings_button = $MenuPanel/MenuContainer/SettingsButton
@onready var main_menu_button = $MenuPanel/MenuContainer/MainMenuButton
@onready var quit_button = $MenuPanel/MenuContainer/QuitButton

signal resume_requested
signal settings_requested
signal main_menu_requested
signal quit_requested

func _ready():
	# 连接按钮信号
	resume_button.connect("pressed", self, "_on_resume_pressed")
	settings_button.connect("pressed", self, "_on_settings_pressed")
	main_menu_button.connect("pressed", self, "_on_main_menu_pressed")
	quit_button.connect("pressed", self, "_on_quit_pressed")

func show_menu():
	show()
	get_tree().paused = true

func hide_menu():
	hide()
	get_tree().paused = false

func _on_resume_pressed():
	hide_menu()
	emit_signal("resume_requested")

func _on_settings_pressed():
	emit_signal("settings_requested")

func _on_main_menu_pressed():
	hide_menu()
	get_tree().paused = false
	emit_signal("main_menu_requested")

func _on_quit_pressed():
	emit_signal("quit_requested")