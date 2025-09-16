extends Control

# 制作人员界面控制脚本

@onready var back_button = $MainContainer/CreditsContainer/ButtonContainer/BackButton

func _ready():
	# 连接返回按钮信号
	back_button.connect("pressed", _on_back_pressed)
	
	# 播放进入动画
	play_enter_animation()

func play_enter_animation():
	# 初始状态：透明
	modulate = Color(1, 1, 1, 0)
	
	# 淡入动画
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5)

func _on_back_pressed():
	# 返回主菜单
	get_tree().change_scene_to_file("res://Main.tscn")
