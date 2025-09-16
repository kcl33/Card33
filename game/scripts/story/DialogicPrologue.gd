extends Node

# 使用 Dialogic 2 的序章脚本
# 主角：时雨时光
# 背景：雾雨之都·拉莱耶

signal prologue_finished

func _ready():
	# 等待一帧确保 Dialogic 已加载
	await get_tree().process_frame
	start_prologue()

func start_prologue():
	"""开始序章"""
	print("启动 Dialogic 序章...")
	
	# 启动 Dialogic 对话
	# 这里需要先在 Dialogic 编辑器中创建对话资源
	var dialogic = Dialogic.start("Prologue")
	
	# 连接 Dialogic 信号
	dialogic.timeline_ended.connect(_on_timeline_ended)
	dialogic.event_handled.connect(_on_event_handled)
	
	# 添加到场景
	add_child(dialogic)

func _on_timeline_ended():
	"""对话结束"""
	print("序章对话结束")
	prologue_finished.emit()

func _on_event_handled(event):
	"""处理自定义事件"""
	print("处理事件: ", event)
	
	# 可以在这里处理自定义事件
	# 比如切换背景、播放音效等
	match event.get("event_id", ""):
		"change_background":
			_change_background(event.get("background", ""))
		"play_sound":
			_play_sound(event.get("sound", ""))
		"show_choice":
			_show_choice(event.get("choices", []))

func _change_background(bg_path: String):
	"""切换背景"""
	print("切换背景: ", bg_path)
	# 这里可以切换背景图片

func _play_sound(sound_path: String):
	"""播放音效"""
	print("播放音效: ", sound_path)
	# 这里可以播放音效

func _show_choice(choices: Array):
	"""显示选择"""
	print("显示选择: ", choices)
	# Dialogic 会自动处理选择分支
