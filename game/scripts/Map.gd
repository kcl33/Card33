extends Control

# 杀戮尖塔风格的地图UI

@onready var map_container = $MapContainer
@onready var map_generator = $MapGenerator

# 当前节点
var current_node_id: String = ""

func _ready():
	# 生成地图
	_generate_map()

# 生成地图
func _generate_map():
	map_generator.generate_map()
	
	# 设置起始节点为当前节点
	current_node_id = "start"
	map_generator.set_current_node(current_node_id)
	map_generator.visit_node(current_node_id)

# 选择下一个节点
func select_next_node(node_id: String):
	if _is_valid_move(node_id):
		# 标记当前节点为已访问
		map_generator.visit_node(current_node_id)
		
		# 更新当前节点
		current_node_id = node_id
		map_generator.set_current_node(current_node_id)
		
		# 根据节点类型执行相应操作
		_handle_node_action(node_id)

# 检查移动是否有效
func _is_valid_move(node_id: String) -> bool:
	var next_nodes = map_generator.get_next_nodes(current_node_id)
	for node in next_nodes:
		if node.node_id == node_id:
			return true
	return false

# 处理节点操作
func _handle_node_action(node_id: String):
	var node = map_generator.map_nodes[node_id]
	match node.node_type:
		map_generator.NodeType.BATTLE:
			print("进入战斗节点: ", node_id)
			# 这里可以触发战斗场景
			_enter_battle()
		map_generator.NodeType.ELITE:
			print("进入精英战斗节点: ", node_id)
			# 这里可以触发精英战斗场景
			_enter_elite_battle()
		map_generator.NodeType.MERCHANT:
			print("进入商人节点: ", node_id)
			# 这里可以打开商店界面
			_open_merchant()
		map_generator.NodeType.TREASURE:
			print("进入宝藏节点: ", node_id)
			# 这里可以获得奖励
			_open_treasure()
		map_generator.NodeType.REST:
			print("进入休息节点: ", node_id)
			# 这里可以恢复生命值或升级卡牌
			_rest()
		map_generator.NodeType.BOSS:
			print("进入Boss战斗节点: ", node_id)
			# 这里触发Boss战斗
			_enter_boss_battle()
		map_generator.NodeType.MYSTERY:
			print("进入神秘节点: ", node_id)
			# 随机事件
			_random_event()
		_:
			print("未知节点类型")

# 进入普通战斗
func _enter_battle():
	# 这里可以加载战斗场景
	print("加载普通战斗场景...")

# 进入精英战斗
func _enter_elite_battle():
	# 这里可以加载精英战斗场景
	print("加载精英战斗场景...")

# 打开商店
func _open_merchant():
	# 这里可以打开商店界面
	print("打开商店界面...")

# 打开宝藏
func _open_treasure():
	# 这里可以获得奖励
	print("获得宝藏奖励...")

# 休息
func _rest():
	# 这里可以恢复生命值或升级卡牌
	print("角色休息恢复...")

# 进入Boss战斗
func _enter_boss_battle():
	# 这里触发Boss战斗
	print("加载Boss战斗场景...")

# 随机事件
func _random_event():
	# 处理随机事件
	print("触发随机事件...")