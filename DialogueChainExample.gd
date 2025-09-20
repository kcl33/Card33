extends Node

# 对话链使用示例

func example_single_dialogue():
	"""单个对话示例（会返回主菜单）"""
	var dialogue_scene = preload("res://game/scenes/ui/DialogicPrologue.tscn")
	var instance = dialogue_scene.instantiate()
	
	# 配置单个对话
	instance.dialogue_chain = ["prologue"]
	instance.return_to_menu_after_chain = true
	
	add_child(instance)

func example_dialogue_chain():
	"""对话链示例（连续多个对话）"""
	var dialogue_scene = preload("res://game/scenes/ui/DialogicPrologue.tscn")
	var instance = dialogue_scene.instantiate()
	
	# 配置对话链
	instance.dialogue_chain = [
		"prologue",      # 序章
		"chapter1",      # 第一章
		"chapter2"       # 第二章
	]
	instance.return_to_menu_after_chain = true  # 完成后返回主菜单
	
	add_child(instance)

func example_dialogue_chain_no_menu():
	"""对话链示例（不返回主菜单，继续游戏）"""
	var dialogue_scene = preload("res://game/scenes/ui/DialogicPrologue.tscn")
	var instance = dialogue_scene.instantiate()
	
	# 配置对话链
	instance.dialogue_chain = [
		"tutorial1",
		"tutorial2", 
		"tutorial3"
	]
	instance.return_to_menu_after_chain = false  # 不返回主菜单
	
	# 连接信号来处理对话链完成后的逻辑
	instance.dialogue_chain_finished.connect(_on_tutorial_finished)
	
	add_child(instance)

func _on_tutorial_finished():
	"""教程对话完成后的处理"""
	print("教程完成，进入游戏主界面")
	# 在这里处理跳转到游戏主界面的逻辑
	# get_tree().change_scene_to_file("res://game/scenes/MainGame.tscn")