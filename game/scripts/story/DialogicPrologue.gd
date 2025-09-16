extends Node

# 序章脚本
# 主角：时雨时光
# 背景：雾雨之都·拉莱耶

signal prologue_finished

func _ready():
	# 等待一帧确保系统已加载
	await get_tree().process_frame
	start_prologue()

func start_prologue():
	"""开始序章"""
	print("启动序章...")
	
	# 直接使用备用序章系统
	_start_fallback_prologue()

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

