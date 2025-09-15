extends Control

# 节点类型枚举
enum NodeType {
	START,
	BATTLE,
	ELITE,
	MERCHANT,
	TREASURE,
	REST,
	BOSS,
	MYSTERY
}

# 节点属性（Godot 4 导出语法）
@export var node_type: NodeType = NodeType.BATTLE
@export var node_id: String = ""
@export var is_visited: bool = false
@export var is_current: bool = false

# 节点连接（存储连接的节点ID）
var connections: Array[String] = []

# UI元素
@onready var background: ColorRect = $Background
@onready var icon: TextureRect = $Icon
@onready var highlight: Control = $Highlight


func _ready():
	_update_visuals()

# 更新节点视觉效果
func _update_visuals():
	match node_type:
		NodeType.START:
			background.color = Color(0.2, 0.8, 0.2)  # 绿色
			icon.texture = null  # 可以设置起始图标
		NodeType.BATTLE:
			background.color = Color(0.8, 0.2, 0.2)  # 红色
		NodeType.ELITE:
			background.color = Color(0.9, 0.5, 0.1)  # 橙色
		NodeType.MERCHANT:
			background.color = Color(0.2, 0.8, 0.8)  # 青色
		NodeType.TREASURE:
			background.color = Color(1.0, 1.0, 0.2)  # 黄色
		NodeType.REST:
			background.color = Color(0.5, 0.2, 0.8)  # 紫色
		NodeType.BOSS:
			background.color = Color(0.1, 0.1, 0.1)  # 黑色
		NodeType.MYSTERY:
			background.color = Color(0.5, 0.5, 0.5)  # 灰色
	
	# 更新访问状态视觉效果
	if is_visited:
		modulate = Color(0.7, 0.7, 0.7)
	elif is_current:
		modulate = Color(1.2, 1.2, 1.2)
	else:
		modulate = Color(1, 1, 1)

# 添加连接
func add_connection(node_id: String):
	if not connections.has(node_id):
		connections.append(node_id)

# 移除连接
func remove_connection(node_id: String):
	connections.erase(node_id)

# 设置为已访问
func set_visited():
	is_visited = true
	_update_visuals()

# 设置为当前节点
func set_current():
	is_current = true
	_update_visuals()

# 取消当前节点状态
func unset_current():
	is_current = false
	_update_visuals()