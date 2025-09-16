extends CanvasLayer

# 简化版序章UI控制器
# 用于测试基本功能

signal prologue_finished

@onready var background := $Background
@onready var text_container := $TextContainer
@onready var title_label := $TextContainer/TitleLabel
@onready var story_text := $TextContainer/StoryText
@onready var continue_prompt := $TextContainer/ContinuePrompt

var current_story_index := 0

# 简化的故事内容
var story_segments := [
	{
		"title": "雾雨之都·拉莱耶",
		"text": "雨水不断滴落在这座废墟般的城市中。\n\n时雨时光站在破败的街道上，雨水混合着血水，在脚下形成暗红色的水洼。"
	},
	{
		"title": "时雨时光",
		"text": "妹妹...时彩...\n\n[时雨时光的声音颤抖着，眼中满含泪水]"
	},
	{
		"title": "回忆",
		"text": "就在不远处，时雨时彩的尸体静静地躺在废墟中。\n\n她的衣服被撕破，身上满是伤痕..."
	},
	{
		"title": "贵族的声音",
		"text": "\"这就是反抗的下场！\"\n\n[远处传来贵族傲慢的声音]"
	},
	{
		"title": "时雨时光",
		"text": "你们...你们这些畜生！\n\n[时雨时光握紧拳头，眼中燃烧着复仇的火焰]"
	},
	{
		"title": "选择",
		"text": "时雨时光面临着选择：\n\n接受命运，成为下一个受害者...\n\n或者，逃离这里，寻找复仇的机会。"
	},
	{
		"title": "时雨时光",
		"text": "我选择...复仇！\n\n[时雨时光擦干眼泪，转身消失在雨夜中]"
	},
	{
		"title": "新的开始",
		"text": "在城市的边缘，时雨时光遇到了一个神秘的AI机器人。\n\n\"你好，我是Loftana。\"\n\n\"你想学习卡普洛斯的力量吗？\""
	}
]

func _ready():
	print("SimplePrologueUI ready")
	
	# 检查关键节点是否存在
	if not background:
		print("ERROR: Background node not found!")
		return
	if not title_label:
		print("ERROR: TitleLabel node not found!")
		return
	if not story_text:
		print("ERROR: StoryText node not found!")
		return
	if not continue_prompt:
		print("ERROR: ContinuePrompt node not found!")
		return
	
	print("All critical nodes found, starting prologue...")
	
	# 设置输入处理
	set_process_input(true)
	
	# 开始序章
	await get_tree().create_timer(1.0).timeout
	_start_prologue()

func _start_prologue():
	"""开始序章"""
	print("开始序章演出...")
	
	# 淡入背景
	var fade_tween = create_tween()
	fade_tween.tween_property(background, "modulate", Color(1, 1, 1, 1), 2.0)
	fade_tween.set_trans(Tween.TRANS_QUART)
	fade_tween.set_ease(Tween.EASE_OUT)
	
	await fade_tween.finished
	
	# 开始显示故事
	_show_next_story_segment()

func _show_next_story_segment():
	"""显示下一个故事段落"""
	if current_story_index >= story_segments.size():
		_finish_prologue()
		return
	
	var segment = story_segments[current_story_index]
	print("显示故事段落: ", segment.title)
	
	# 更新标题和文本
	title_label.text = segment.title
	story_text.text = segment.text
	
	# 淡入标题
	var title_tween = create_tween()
	title_tween.tween_property(title_label, "modulate:a", 1.0, 1.0)
	title_tween.set_trans(Tween.TRANS_QUART)
	title_tween.set_ease(Tween.EASE_OUT)
	
	await title_tween.finished
	await get_tree().create_timer(0.5).timeout
	
	# 淡入文本
	var text_tween = create_tween()
	text_tween.tween_property(story_text, "modulate:a", 1.0, 1.0)
	text_tween.set_trans(Tween.TRANS_QUART)
	text_tween.set_ease(Tween.EASE_OUT)
	
	await text_tween.finished
	await get_tree().create_timer(0.5).timeout
	
	# 显示继续提示
	_show_continue_prompt()

func _show_continue_prompt():
	"""显示继续提示"""
	continue_prompt.modulate.a = 1.0
	
	# 闪烁效果
	var blink_tween = create_tween()
	blink_tween.set_loops()
	blink_tween.tween_property(continue_prompt, "modulate:a", 0.3, 1.0)
	blink_tween.tween_property(continue_prompt, "modulate:a", 1.0, 1.0)

func _input(event):
	"""处理输入"""
	if event is InputEventKey and event.pressed:
		# 继续下一个段落
		_hide_current_segment()
		current_story_index += 1
		await get_tree().create_timer(0.5).timeout
		_show_next_story_segment()

func _hide_current_segment():
	"""隐藏当前段落"""
	# 停止闪烁效果
	continue_prompt.get_tree().create_tween().kill()
	
	# 淡出所有元素
	var hide_tween = create_tween()
	hide_tween.parallel().tween_property(title_label, "modulate:a", 0.0, 0.5)
	hide_tween.parallel().tween_property(story_text, "modulate:a", 0.0, 0.5)
	hide_tween.parallel().tween_property(continue_prompt, "modulate:a", 0.0, 0.5)
	
	await hide_tween.finished

func _finish_prologue():
	"""完成序章"""
	print("序章完成")
	
	# 淡出所有元素
	var fade_tween = create_tween()
	fade_tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 2.0)
	fade_tween.set_trans(Tween.TRANS_QUART)
	fade_tween.set_ease(Tween.EASE_IN)
	
	await fade_tween.finished
	
	# 发出完成信号
	prologue_finished.emit()
	
	# 移除自己
	queue_free()
