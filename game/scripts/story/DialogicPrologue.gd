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
	
	# 检查 Dialogic 是否可用
	if not _is_dialogic_available():
		print("Dialogic 插件未加载，使用备用序章...")
		_start_fallback_prologue()
		return
	
	# 启动 Dialogic 对话
	# 这里需要先在 Dialogic 编辑器中创建对话资源
	var dialogic_handler = DialogicGameHandler.new()
	var dialogic_node = dialogic_handler.start("Prologue")
	
	if dialogic_node:
		# 连接 Dialogic 信号
		dialogic_node.timeline_ended.connect(_on_timeline_ended)
		dialogic_node.event_handled.connect(_on_event_handled)
		
		# 添加到场景
		add_child(dialogic_node)
	else:
		print("无法启动 Dialogic 对话，使用备用序章...")
		_start_fallback_prologue()

func _is_dialogic_available() -> bool:
	"""检查 Dialogic 是否可用"""
	return ClassDB.class_exists("DialogicGameHandler")

func _start_fallback_prologue():
	"""备用序章（当 Dialogic 不可用时）"""
	print("使用备用序章系统...")
	
	# 简单的文本序章
	var prologue_text = """
	雾雨之都·拉莱耶
	
	时雨时光站在废墟中，雨水不断滴落。
	妹妹时雨时彩的尸体就在不远处...
	
	贵族的声音在远处响起：
	"这就是反抗的下场！"
	
	时雨时光握紧拳头，眼中燃烧着复仇的火焰。
	
	[按任意键继续...]
	"""
	
	print(prologue_text)
	
	# 等待用户输入
	await get_tree().create_timer(3.0).timeout
	print("序章结束，进入主游戏...")
	prologue_finished.emit()

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
