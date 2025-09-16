extends Control

# 主游戏入口点
# 直接加载新的UI系统

func _ready():
	print("Welcome to 卡普洛斯的33个幻想!")
	print("Loading main UI system...")
	
	# 直接加载新的UI系统
	load_main_ui()

func load_main_ui():
	"""加载主UI系统"""
	print("Loading UIIntroLayer...")
	
	# 加载新的UI场景
	var ui_scene = preload("res://game/scenes/ui/UIIntroLayer.tscn")
	var ui_instance = ui_scene.instantiate()
	add_child(ui_instance)
	
	print("Main UI loaded successfully!")
