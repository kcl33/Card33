extends Node

# 卡牌类型枚举
enum CardType {
	MONSTER,  # 怪兽卡
	SPELL,    # 法术卡
	POLICY,   # 政策卡
	COMPONENT # 组件卡
}

# 位置枚举（主要用于怪兽卡）
enum Position {
	ATTACK,           # 表侧攻击表示
	DEFENSE,          # 表侧守备表示
	FACE_DOWN_ATTACK, # 里侧攻击表示
	FACE_DOWN_DEFENSE # 里侧守备表示
}

# 组件类型枚举（仅组件卡使用）
enum ComponentType {
	WEAPON,   # 武器
	MOBILITY, # 移动
	DEFENSE,  # 防御
	UTILITY  # 实用
}

# 基本属性
var card_name = "默认卡牌"
var card_type = CardType.MONSTER
var cost = 1
var description = "默认描述"
var owner = null  # 卡牌所有者（玩家）

# 怪兽卡属性
var attack = 0
var defense = 0
var position = Position.FACE_DOWN_ATTACK  # 默认为里侧攻击表示

# 组件卡属性
var component_type = null

# 魔法陷阱卡属性
var is_face_down = true  # 是否为盖伏状态

# 组件列表
var components = []

# 卡牌脚本
var card_script = null

# 卡牌效果触发标志
var effect_triggered = false

func _init():
	pass

# 添加组件
func add_component(component):
	components.append(component)
	
	# 根据组件类型应用效果
	match component.component_type:
		ComponentType.WEAPON:
			attack += 500
		ComponentType.MOBILITY:
			attack += 100
			defense -= 100
		ComponentType.DEFENSE:
			defense += 300
		ComponentType.UTILITY:
			# 实用组件效果
			pass

# 检查是否可以安装组件
func can_attach_component(component):
	if card_type != CardType.MONSTER:
		return false
	return true

# 设置卡牌表示形式
func set_position(new_position):
	position = new_position

# 翻转卡牌（里侧变表侧，表侧变里侧）
func flip():
	match position:
		Position.ATTACK:
			position = Position.FACE_DOWN_ATTACK
		Position.DEFENSE:
			position = Position.FACE_DOWN_DEFENSE
		Position.FACE_DOWN_ATTACK:
			position = Position.ATTACK
		Position.FACE_DOWN_DEFENSE:
			position = Position.DEFENSE

# 获取攻击力（考虑组件加成）
func get_attack():
	var total_attack = attack
	for component in components:
		if component.component_type == ComponentType.WEAPON:
			total_attack += 500
		elif component.component_type == ComponentType.MOBILITY:
			total_attack += 100
	return total_attack

# 获取守备力（考虑组件加成）
func get_defense():
	var total_defense = defense
	for component in components:
		if component.component_type == ComponentType.DEFENSE:
			total_defense += 300
		elif component.component_type == ComponentType.MOBILITY:
			total_defense -= 100
	return total_defense

# 设置卡牌所有者
func set_owner(player):
	owner = player

# 设置卡牌脚本
func set_card_script(script):
	card_script = script

# 触发卡牌效果
func trigger_effect(effect_name, args=null):
	if card_script != null and card_script.has_method(effect_name):
		if args != null:
			card_script.call(effect_name, args)
		else:
			card_script.call(effect_name)
