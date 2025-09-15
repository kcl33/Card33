extends Node

# 地图生成器类，用于生成类似杀戮尖塔的地图

# 节点类型枚举
enum NodeType {
	START,      # 起始节点
	BATTLE,     # 战斗节点
	ELITE,      # 精英战斗节点
	MERCHANT,   # 商人节点
	TREASURE,   # 宝藏节点
	REST,       # 休息节点
	BOSS,       # Boss节点
	MYSTERY     # 神秘节点
}

# 地图配置
const MAP_WIDTH = 1200
const MAP_HEIGHT = 800
const NODE_SPACING_X = 200
const NODE_SPACING_Y = 150
const ROWS = 5
const MIN_NODES_PER_ROW = 3
const MAX_NODES_PER_ROW = 5

# 地图数据
var map_nodes = {}  # 存储所有节点 {id: node_instance}
var current_path = []  # 当前路径

# 生成地图
func generate_map():
	clear_map()
	
	# 生成起始节点
	var start_node = _create_node(NodeType.START, "start")
	start_node.position = Vector2(MAP_WIDTH/2 - 30, 20)
	add_child(start_node)
	map_nodes[start_node.node_id] = start_node
	
	# 生成中间层节点
	var prev_row_nodes = [start_node]
	for row in range(ROWS - 1):
		var row_nodes = _generate_row(row + 1, prev_row_nodes)
		_connect_rows(prev_row_nodes, row_nodes)
		prev_row_nodes = row_nodes
	
	# 生成Boss节点
	var boss_node = _create_node(NodeType.BOSS, "boss")
	boss_node.position = Vector2(MAP_WIDTH/2 - 30, MAP_HEIGHT - 80)
	add_child(boss_node)
	map_nodes[boss_node.node_id] = boss_node
	
	# 连接最后一行到Boss节点
	for node in prev_row_nodes:
		node.add_connection(boss_node.node_id)
		boss_node.add_connection(node.node_id)  # 双向连接
	
	return map_nodes

# 清除地图
func clear_map():
	for node in get_children():
		if node.has_method("get_node_id"):
			node.queue_free()
	map_nodes.clear()
	current_path.clear()

# 生成一行节点
func _generate_row(row_index, prev_row_nodes):
	var nodes = []
	var node_count = randi() % (MAX_NODES_PER_ROW - MIN_NODES_PER_ROW + 1) + MIN_NODES_PER_ROW
	
	# 计算节点的水平分布
	var total_width = (node_count - 1) * NODE_SPACING_X
	var start_x = (MAP_WIDTH - total_width) / 2
	
	for i in range(node_count):
		# 确定节点类型
		var node_type = _determine_node_type(row_index, i, node_count)
		
		# 创建节点
		var node_id = "node_" + str(row_index) + "_" + str(i)
		var node = _create_node(node_type, node_id)
		
		# 设置位置
		var x = start_x + i * NODE_SPACING_X
		var y = 80 + row_index * NODE_SPACING_Y
		node.position = Vector2(x, y)
		
		# 添加到场景和字典中
		add_child(node)
		map_nodes[node_id] = node
		nodes.append(node)
	
	return nodes

# 确定节点类型
func _determine_node_type(row_index, node_index, node_count):
	# 第一行特殊处理
	if row_index == 1:
		# 第一行不生成Boss、Start或Elite
		var types = [NodeType.BATTLE, NodeType.MERCHANT, NodeType.TREASURE, NodeType.REST, NodeType.MYSTERY]
		return types[randi() % types.size()]
	
	# 最后一行前的特殊处理
	if row_index == ROWS - 1:
		# 最后一行前增加Elite概率
		var rand_val = randf()
		if rand_val < 0.1:
			return NodeType.ELITE
		elif rand_val < 0.3:
			return NodeType.MERCHANT
		elif rand_val < 0.5:
			return NodeType.TREASURE
		elif rand_val < 0.6:
			return NodeType.REST
		else:
			return NodeType.BATTLE
	
	# 普通行
	var rand_val = randf()
	if rand_val < 0.05:
		return NodeType.ELITE
	elif rand_val < 0.15:
		return NodeType.MERCHANT
	elif rand_val < 0.25:
		return NodeType.TREASURE
	elif rand_val < 0.35:
		return NodeType.REST
	elif rand_val < 0.40:
		return NodeType.MYSTERY
	else:
		return NodeType.BATTLE

# 创建节点实例
func _create_node(node_type, node_id):
	var node_scene = preload("res://game/scenes/MapNode.tscn")
	var node = node_scene.instantiate()
	node.node_type = node_type
	node.node_id = node_id
	return node

# 连接两行节点
func _connect_rows(prev_row_nodes, current_row_nodes):
	# 确保每个节点至少连接一个上层节点
	for i in range(current_row_nodes.size()):
		var current_node = current_row_nodes[i]
		var connected = false
		
		# 尝试连接最近的上层节点
		var closest_nodes = _get_closest_nodes(current_node, prev_row_nodes, 2)
		for prev_node in closest_nodes:
			# 建立双向连接
			current_node.add_connection(prev_node.node_id)
			prev_node.add_connection(current_node.node_id)
			connected = true
		
		# 如果没有连接到任何节点，则连接到最近的一个
		if not connected and prev_row_nodes.size() > 0:
			var closest = _get_closest_nodes(current_node, prev_row_nodes, 1)[0]
			current_node.add_connection(closest.node_id)
			closest.add_connection(current_node.node_id)

# 获取最近的节点
func _get_closest_nodes(target_node, node_list, count):
	var sorted_nodes = node_list.duplicate()
	sorted_nodes.sort_custom(Callable(self, "_sort_by_distance_to_target"))
	
	var result = []
	for i in range(min(count, sorted_nodes.size())):
		result.append(sorted_nodes[i])
	
	return result

# 排序函数：按距离目标节点排序
func _sort_by_distance_to_target(a, b):
	var target_pos = Vector2(MAP_WIDTH/2, 0)  # 简化的排序目标
	var dist_a = a.position.distance_to(target_pos)
	var dist_b = b.position.distance_to(target_pos)
	return dist_a < dist_b

# 设置当前节点
func set_current_node(node_id):
	# 取消之前节点的当前状态
	for node in map_nodes.values():
		node.unset_current()
	
	# 设置新节点为当前节点
	if map_nodes.has(node_id):
		map_nodes[node_id].set_current()
		current_path.append(node_id)

# 访问节点
func visit_node(node_id):
	if map_nodes.has(node_id):
		map_nodes[node_id].set_visited()

# 获取可访问的下一个节点
func get_next_nodes(current_node_id):
	if map_nodes.has(current_node_id):
		var current_node = map_nodes[current_node_id]
		var next_nodes = []
		for node_id in current_node.connections:
			if map_nodes.has(node_id):
				next_nodes.append(map_nodes[node_id])
		return next_nodes
	return []
