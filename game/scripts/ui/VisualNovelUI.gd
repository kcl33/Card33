extends CanvasLayer

# 视觉小说UI系统
# 用于显示对话、选择分支和剧情推进

@onready var dialogue_box := $DialogueBox
@onready var character_portrait := $CharacterPortrait
@onready var background_image := $BackgroundImage
@onready var choice_menu := $ChoiceMenu
@onready var text_label := $DialogueBox/TextLabel
@onready var name_label := $DialogueBox/NameLabel

var current_dialogue_data = {}
var is_typing = false
var typing_speed = 0.05

signal dialogue_finished
signal choice_selected(choice_index: int)

func _ready():
	# 初始状态隐藏所有UI
	dialogue_box.visible = false
	character_portrait.visible = false
	background_image.visible = false
	choice_menu.visible = false

func show_dialogue(dialogue_data: Dictionary):
	"""显示对话"""
	current_dialogue_data = dialogue_data
	
	# 设置背景
	if dialogue_data.has("background"):
		_set_background(dialogue_data.background)
	
	# 设置角色立绘
	if dialogue_data.has("character"):
		_set_character_portrait(dialogue_data.character)
	
	# 设置角色名称
	if dialogue_data.has("character"):
		name_label.text = _get_character_name(dialogue_data.character)
	
	# 显示对话框
	dialogue_box.visible = true
	character_portrait.visible = true
	background_image.visible = true
	
	# 开始打字效果
	_start_typing_effect(dialogue_data.text)

func _set_background(bg_path: String):
	"""设置背景图片"""
	if bg_path != "":
		var texture = load(bg_path)
		if texture:
			background_image.texture = texture

func _set_character_portrait(character: String):
	"""设置角色立绘"""
	var portrait_path = "res://assets/characters/" + character + ".png"
	var texture = load(portrait_path)
	if texture:
		character_portrait.texture = texture

func _get_character_name(character: String) -> String:
	"""获取角色显示名称"""
	match character:
		"narrator":
			return "时雨时光"
		"robot":
			return "洛芙塔娜"
		"noble":
			return "贵族"
		_:
			return character

func _start_typing_effect(text: String):
	"""开始打字效果"""
	is_typing = true
	text_label.text = ""
	
	for i in range(text.length()):
		if not is_typing:
			break
		
		text_label.text += text[i]
		await get_tree().create_timer(typing_speed).timeout
	
	is_typing = false
	dialogue_finished.emit()

func show_choices(choices: Array):
	"""显示选择菜单"""
	choice_menu.visible = true
	
	# 清除旧的选择按钮
	for child in choice_menu.get_children():
		child.queue_free()
	
	# 创建新的选择按钮
	for i in range(choices.size()):
		var button = Button.new()
		button.text = choices[i]
		button.pressed.connect(_on_choice_button_pressed.bind(i))
		choice_menu.add_child(button)

func _on_choice_button_pressed(choice_index: int):
	"""选择按钮被点击"""
	choice_menu.visible = false
	choice_selected.emit(choice_index)

func _input(event):
	"""处理输入"""
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_typing:
				# 如果正在打字，立即完成
				is_typing = false
				text_label.text = current_dialogue_data.get("text", "")
				dialogue_finished.emit()
			elif dialogue_box.visible and not choice_menu.visible:
				# 如果对话完成，继续下一句
				dialogue_finished.emit()

func hide_all():
	"""隐藏所有UI"""
	dialogue_box.visible = false
	character_portrait.visible = false
	background_image.visible = false
	choice_menu.visible = false
