extends Node

# 序章剧情脚本 - 基于用户提供的详细剧情
# 主角：时雨时光
# 背景：雾雨之都·拉莱耶

signal prologue_finished

# 定义剧情阶段
enum PrologueStage {
	RECALL_CHILDHOOD,    # 回忆童年
	PRESENT_LIFE,        # 现在的生活
	TRAGEDY,             # 悲剧发生
	CHOICE,              # 关键选择
	ESCAPE,              # 逃亡之路
	MEET_ROBOT,          # 遇到洛芙塔娜
	LEARN_RULES,         # 学习卡普洛斯卡
	FIRST_BATTLE         # 第一次战斗
}

var current_stage = PrologueStage.RECALL_CHILDHOOD
var current_dialogue_index = 0

# 序章对话数据
var dialogue_data = {
	PrologueStage.RECALL_CHILDHOOD: [
		{
			"background": "res://assets/backgrounds/monster_attack.jpg",
			"character": "narrator",
			"text": "三年前的那个雨夜，我永远无法忘记...",
			"mood": "dark"
		},
		{
			"character": "narrator", 
			"text": "父母在我面前被那些从卡普洛斯幻想中诞生的怪兽撕碎...",
			"mood": "tragic"
		},
		{
			"character": "narrator",
			"text": "我抱着妹妹时雨时彩，在废墟中瑟瑟发抖...",
			"mood": "despair"
		}
	],
	
	PrologueStage.PRESENT_LIFE: [
		{
			"background": "res://assets/backgrounds/rainy_city.jpg",
			"character": "narrator",
			"text": "三年后，我们在幸存者建立的都市'雾雨之都·拉莱耶'中苟延残喘...",
			"mood": "melancholy"
		},
		{
			"character": "narrator",
			"text": "为了妹妹时彩的生日，我攒了好久的钱，想给她买一个蛋糕...",
			"mood": "hopeful"
		},
		{
			"character": "narrator",
			"text": "可是在这个残酷的世界里，我们只是最底层的蝼蚁...",
			"mood": "bitter"
		}
	],
	
	PrologueStage.TRAGEDY: [
		{
			"background": "res://assets/backgrounds/noble_estate.jpg",
			"character": "narrator",
			"text": "直到那一天...贵族们看上了时彩的美貌...",
			"mood": "ominous"
		},
		{
			"character": "narrator",
			"text": "他们强暴了她，然后杀害了她，最后嫁祸给我...",
			"mood": "rage"
		},
		{
			"character": "narrator",
			"text": "而我，只是想用攒下的钱给妹妹买一个生日蛋糕...",
			"mood": "heartbreak"
		}
	],
	
	PrologueStage.CHOICE: [
		{
			"background": "res://assets/backgrounds/prison_cell.jpg",
			"character": "narrator",
			"text": "现在，我被关在牢房里，等待着审判...",
			"mood": "desperate"
		},
		{
			"character": "narrator",
			"text": "这个世界已经彻底击败了我...",
			"mood": "defeated"
		},
		{
			"character": "narrator",
			"text": "但是...但是我还不能死！",
			"mood": "determined"
		}
	]
}

func _ready():
	start_prologue()

func start_prologue():
	"""开始序章"""
	print("开始序章剧情...")
	_show_next_dialogue()

func _show_next_dialogue():
	"""显示下一段对话"""
	if current_stage in dialogue_data:
		var stage_dialogues = dialogue_data[current_stage]
		if current_dialogue_index < stage_dialogues.size():
			var dialogue = stage_dialogues[current_dialogue_index]
			_display_dialogue(dialogue)
			current_dialogue_index += 1
		else:
			# 当前阶段结束，进入下一阶段
			_advance_to_next_stage()
	else:
		# 没有对话数据的阶段直接进入下一阶段
		_advance_to_next_stage()

func _display_dialogue(dialogue):
	"""显示对话"""
	print("显示对话: ", dialogue.text)
	# 这里应该调用视觉小说UI显示对话
	# 暂时用print代替，等待一定时间后继续
	await get_tree().create_timer(2.0).timeout
	_show_next_dialogue()

func _advance_to_next_stage():
	"""进入下一剧情阶段"""
	match current_stage:
		PrologueStage.RECALL_CHILDHOOD:
			current_stage = PrologueStage.PRESENT_LIFE
			current_dialogue_index = 0
			_show_next_dialogue()
		PrologueStage.PRESENT_LIFE:
			current_stage = PrologueStage.TRAGEDY
			current_dialogue_index = 0
			_show_next_dialogue()
		PrologueStage.TRAGEDY:
			current_stage = PrologueStage.CHOICE
			current_dialogue_index = 0
			_show_next_dialogue()
		PrologueStage.CHOICE:
			_show_choice_menu()
		PrologueStage.ESCAPE:
			_show_escape_sequence()
		PrologueStage.MEET_ROBOT:
			_show_meeting_robot()
		PrologueStage.LEARN_RULES:
			_show_card_rules()
		PrologueStage.FIRST_BATTLE:
			_show_tutorial_battle()
		_:
			_finish_prologue()

func _show_choice_menu():
	"""显示选择菜单"""
	print("显示选择菜单...")
	print("选择1: 就此认命，承认被这残酷的世界击败")
	print("选择2: 逃跑，逃避，然后背负上这一切，残酷地活下去")
	
	# 模拟等待选择
	await get_tree().create_timer(1.0).timeout
	# 默认选择逃跑（在实际游戏中会由玩家选择）
	_on_choice_selected(2)

func _on_choice_selected(choice: int):
	"""处理选择结果"""
	match choice:
		1:
			_show_ending_1()
		2:
			_show_escape_sequence()

func _show_ending_1():
	"""结局1：就此认命"""
	print("结局1: 游戏结束")
	print("你选择就此认命，承认被这残酷的世界击败。")
	print("时雨时光在绝望中闭上了眼睛，再也没有醒来...")
	# 显示游戏结束画面
	prologue_finished.emit()

func _show_escape_sequence():
	"""逃跑序列"""
	print("开始逃跑序列...")
	current_stage = PrologueStage.ESCAPE
	_show_escape_story()

func _show_escape_story():
	"""逃亡故事"""
	print("宪兵卫队的追击声在身后响起...")
	print("时雨时光拼尽全力在狭窄的巷道中穿行...")
	print("穿过贫民区，越过废弃的建筑，最终躲藏到城市边缘的垃圾场...")
	
	await get_tree().create_timer(2.0).timeout
	_show_meeting_robot()

func _show_meeting_robot():
	"""遇到机器人"""
	print("在垃圾场的废铁堆中，时雨时光遇到了一台几乎报废的AI机器人...")
	print("机器人用微弱的电子音说道：'你...你还好吗？'")
	print("时雨时光惊讶地看着这台机器人：'你...你会说话？'")
	
	await get_tree().create_timer(2.0).timeout
	_show_card_rules()

func _show_card_rules():
	"""介绍卡普洛斯卡规则"""
	print("我是洛芙塔娜，一台被废弃的AI机器人。")
	print("我知道你现在很绝望，但有一种方法可以改变这一切。")
	print("在卡普洛斯的幻想中，有一条规则叫做'卡普洛斯卡'...")
	print("这是一条只要被提出就必须执行的卡牌战斗规则。")
	print("一场赌上灵魂、过去、现在、未来的战斗。")
	print("通过这种方式，你可以向那些贵族复仇。")
	
	await get_tree().create_timer(3.0).timeout
	_show_tutorial_battle()

func _show_tutorial_battle():
	"""新手战斗教程"""
	print("洛芙塔娜将她身上的机械人卡组交给了时雨时光。")
	print("'这些是基础卡牌，我会教你如何使用它们。'")
	print("'卡牌战斗不仅仅是力量的较量，更是意志的对抗。'")
	print("'现在，让我来教你基本的战斗规则...'")
	
	await get_tree().create_timer(2.0).timeout
	_finish_prologue()

func _finish_prologue():
	"""完成序章"""
	print("序章结束，进入主游戏...")
	prologue_finished.emit()