extends Node2D

# Dialogic序章场景控制器
# 使用Dialogic插件来显示序章内容

signal prologue_finished(next_scene: String)
signal dialogue_chain_finished

# 对话链配置
var dialogue_chain = [
	"prologue",
	# "chapter1",
	# "chapter2"
]
var current_dialogue_index = 0
var return_to_menu_after_chain = true

func _ready():
	# 确保Dialogic系统已加载
	if Dialogic:
		print("Dialogic系统已就绪")
		# 启动对话链
		start_dialogue_chain()
	else:
		print("Dialogic系统未找到")
		_finish_with_menu_return()

func start_dialogue_chain():
	"""启动对话链"""
	if current_dialogue_index < dialogue_chain.size():
		var timeline_name = dialogue_chain[current_dialogue_index]
		print("启动对话: ", timeline_name, " (", current_dialogue_index + 1, "/", dialogue_chain.size(), ")")
		
		# 启动Dialogic时间线
		Dialogic.start(timeline_name)
		
		# 连接Dialogic结束信号
		if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
			Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended)
	else:
		# 所有对话完成
		_finish_dialogue_chain()

func _on_dialogic_timeline_ended():
	"""当前对话结束"""
	var completed_dialogue = dialogue_chain[current_dialogue_index]
	print("对话结束: ", completed_dialogue)
	
	# 移动到下一个对话
	current_dialogue_index += 1
	
	# 检查是否有下一个对话
	if current_dialogue_index < dialogue_chain.size():
		# 继续下一个对话
		print("继续下一个对话...")
		start_dialogue_chain()
	else:
		# 对话链完成
		_finish_dialogue_chain()

func _finish_dialogue_chain():
	"""完成整个对话链"""
	print("对话链完成")
	
	if return_to_menu_after_chain:
		_finish_with_menu_return()
	else:
		# 发送不同的信号，不返回主菜单
		dialogue_chain_finished.emit()
		queue_free()

func _finish_with_menu_return():
	"""完成并返回主菜单"""
	prologue_finished.emit("")
	queue_free()

# 处理用户输入以推进对话
func _input(event):
	if event is InputEventKey and event.pressed:
		if Dialogic:
			# 手动推进对话
			Dialogic.Inputs.handle_input()
	elif event is InputEventMouseButton and event.pressed:
		if Dialogic:
			# 手动推进对话
			Dialogic.Inputs.handle_input()