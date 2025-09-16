extends Node

# 序章脚本 - 末世灰暗废土风格
# 主角：时雨时光
# 背景：雾雨之都·拉莱耶

signal prologue_finished

var current_scene = 0
var dialogue_data = []

func _ready():
	_setup_prologue_data()
	start_prologue()

func _setup_prologue_data():
	# 序章对话数据
	dialogue_data = [
		# 场景1：回忆 - 父母被怪兽吞噬
		{
			"scene": "memory",
			"background": "res://assets/backgrounds/monster_attack.jpg",
			"character": "narrator",
			"text": "三年前的那个雨夜，我永远无法忘记...",
			"mood": "dark"
		},
		{
			"scene": "memory",
			"character": "narrator", 
			"text": "父母在我面前被那些从卡普洛斯幻想中诞生的怪兽撕碎...",
			"mood": "tragic"
		},
		{
			"scene": "memory",
			"character": "narrator",
			"text": "我抱着妹妹时雨时彩，在废墟中瑟瑟发抖...",
			"mood": "despair"
		},
		
		# 场景2：现在 - 雾雨之都·拉莱耶
		{
			"scene": "present",
			"background": "res://assets/backgrounds/rainy_city.jpg",
			"character": "narrator",
			"text": "三年后，我们在幸存者建立的都市'雾雨之都·拉莱耶'中苟延残喘...",
			"mood": "melancholy"
		},
		{
			"scene": "present",
			"character": "narrator",
			"text": "我发誓要保护好妹妹，但在这个残酷的世界里，我们只是最底层的蝼蚁...",
			"mood": "bitter"
		},
		
		# 场景3：悲剧发生
		{
			"scene": "tragedy",
			"background": "res://assets/backgrounds/noble_estate.jpg",
			"character": "narrator",
			"text": "直到那一天...贵族们看上了时彩的美貌...",
			"mood": "ominous"
		},
		{
			"scene": "tragedy",
			"character": "narrator",
			"text": "他们强暴了她，然后杀害了她，最后嫁祸给我...",
			"mood": "rage"
		},
		{
			"scene": "tragedy",
			"character": "narrator",
			"text": "而我，只是想用攒下的钱给妹妹买一个生日蛋糕...",
			"mood": "heartbreak"
		},
		
		# 场景4：命运选择
		{
			"scene": "choice",
			"background": "res://assets/backgrounds/prison_cell.jpg",
			"character": "narrator",
			"text": "现在，我被关在牢房里，等待着审判...",
			"mood": "desperate"
		},
		{
			"scene": "choice",
			"character": "narrator",
			"text": "这个世界已经彻底击败了我...",
			"mood": "defeated"
		},
		{
			"scene": "choice",
			"character": "narrator",
			"text": "但是...但是我还不能死！",
			"mood": "determined"
		}
	]

func start_prologue():
	print("开始序章...")
	_show_dialogue(0)

func _show_dialogue(index: int):
	if index >= dialogue_data.size():
		_show_choice_menu()
		return
	
	var dialogue = dialogue_data[index]
	print("显示对话: ", dialogue.text)
	
	# 这里应该调用视觉小说UI显示对话
	# 暂时用print代替
	await get_tree().create_timer(2.0).timeout
	
	_show_dialogue(index + 1)

func _show_choice_menu():
	print("显示选择菜单...")
	# 这里应该显示选择UI
	# 暂时用print代替
	print("选择1: 就此认命，承认被这残酷的世界击败")
	print("选择2: 逃跑，逃避，然后背负上这一切，残酷地活下去")

func _on_choice_selected(choice: int):
	match choice:
		1:
			_show_ending_1()
		2:
			_show_escape_sequence()

func _show_ending_1():
	print("结局1: 游戏结束")
	# 显示游戏结束画面
	prologue_finished.emit()

func _show_escape_sequence():
	print("开始逃跑序列...")
	# 显示逃跑剧情
	_show_meeting_robot()

func _show_meeting_robot():
	print("在垃圾场遇到AI机器人洛芙塔娜...")
	# 显示与机器人相遇的剧情
	_show_card_rules()

func _show_card_rules():
	print("洛芙塔娜解释卡普洛斯卡规则...")
	# 显示卡牌规则说明
	_show_tutorial_battle()

func _show_tutorial_battle():
	print("开始新手教程战斗...")
	# 进入卡牌战斗教程
	prologue_finished.emit()
