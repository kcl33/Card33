extends Node

# 回合阶段枚举
enum Phase {
	DRAW,         # 抽卡阶段
	STANDBY,      # 准备阶段
	MAIN_1,       # 主要阶段1
	BATTLE,       # 战斗阶段
	MAIN_2,       # 主要阶段2
	END           # 结束阶段
}

var current_phase = Phase.DRAW

func _init():
	pass

func get_phase_name():
	match current_phase:
		Phase.DRAW:
			return "抽卡阶段"
		Phase.STANDBY:
			return "准备阶段"
		Phase.MAIN_1:
			return "主要阶段1"
		Phase.BATTLE:
			return "战斗阶段"
		Phase.MAIN_2:
			return "主要阶段2"
		Phase.END:
			return "结束阶段"
	return "未知阶段"

func next_phase():
	current_phase = (current_phase + 1) % 6