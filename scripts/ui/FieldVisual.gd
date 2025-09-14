extends Control

# 场地可视化节点
var player = null

# 场地各区域的可视化节点
var main_monster_zones = []  # 主要怪兽区域 (5个)
var extra_monster_zone = null  # 额外怪兽区域 (1个)
var spell_trap_zones = []  # 魔法陷阱区域 (5个)
var field_spell_zone = null  # 场地魔法区域
var deck_zone = null  # 卡组区域
var extra_deck_zone = null  # 额外卡组区域
var graveyard_zone = null  # 墓地区域
var banished_zone = null  # 除外区域

# 区域标签
var main_zone_labels = []
var spell_zone_labels = []
var other_zone_labels = []

func _init(player_obj):
	player = player_obj

func _ready():
	setup_field_visual()
	
	# 连接窗口大小变化信号
	get_viewport().connect("size_changed", Callable(self, "_on_window_resized"))
	_on_window_resized()

# 设置场地可视化
func setup_field_visual():
	# 清除现有节点
	for child in get_children():
		child.queue_free()
	
	# 创建主要怪兽区域 (5个)
	for i in range(5):
		var zone = ColorRect.new()
		zone.size = Vector2(80, 120)
		zone.position = Vector2(100 + i * 100, 250)
		zone.color = Color(0.5, 0.5, 0.5, 0.3)
		add_child(zone)
		main_monster_zones.append(zone)
		
		# 添加标签
		var label = Label.new()
		label.text = "前场" + str(i+1)
		label.position = Vector2(100 + i * 100, 230)
		add_child(label)
		main_zone_labels.append(label)
	
	# 创建额外怪兽区域
	extra_monster_zone = ColorRect.new()
	extra_monster_zone.size = Vector2(zone_width, zone_height)
	extra_monster_zone.position = Vector2(field_width - 150, field_height/2 + 20)
	extra_monster_zone.color = Color(1.0, 0.5, 0.5, 0.3)
	add_child(extra_monster_zone)
	
	var extra_label = Label.new()
	extra_label.text = "额外区"
	extra_label.position = Vector2(field_width - 150, field_height/2)
	add_child(extra_label)
	
	# 创建魔法陷阱区域 (5个)
	for i in range(5):
		var zone = ColorRect.new()
		zone.size = Vector2(zone_width, zone_height)
		zone.position = Vector2(100 + i * 100, field_height/2 + zone_height + 40)
		zone.color = Color(0.5, 0.5, 1.0, 0.3)
		add_child(zone)
		spell_trap_zones.append(zone)
		
		# 添加标签
		var label = Label.new()
		label.text = "后场" + str(i+1)
		label.position = Vector2(100 + i * 100, field_height/2 + zone_height + 20)
		add_child(label)
		spell_zone_labels.append(label)
	
	# 创建场地魔法区域
	field_spell_zone = ColorRect.new()
	field_spell_zone.size = Vector2(zone_width, zone_height)
	field_spell_zone.position = Vector2(field_width/2 - zone_width/2, 50)
	field_spell_zone.color = Color(0.5, 1.0, 0.5, 0.3)
	add_child(field_spell_zone)
	
	var field_label = Label.new()
	field_label.text = "场地区"
	field_label.position = Vector2(field_width/2 - zone_width/2, 30)
	add_child(field_label)
	
	# 创建卡组区域
	deck_zone = ColorRect.new()
	deck_zone.size = Vector2(zone_width, zone_height)
	deck_zone.position = Vector2(50, 50)
	deck_zone.color = Color(0.8, 0.8, 0.2, 0.3)
	add_child(deck_zone)
	
	var deck_label = Label.new()
	deck_label.text = "卡组"
	deck_label.position = Vector2(50, 30)
	add_child(deck_label)
	
	# 创建额外卡组区域
	extra_deck_zone = ColorRect.new()
	extra_deck_zone.size = Vector2(zone_width, zone_height)
	extra_deck_zone.position = Vector2(150, 50)
	extra_deck_zone.color = Color(1.0, 0.5, 0.0, 0.3)
	add_child(extra_deck_zone)
	
	var extra_deck_label = Label.new()
	extra_deck_label.text = "额外卡组"
	extra_deck_label.position = Vector2(150, 30)
	add_child(extra_deck_label)
	
	# 创建墓地区域
	graveyard_zone = ColorRect.new()
	graveyard_zone.size = Vector2(zone_width, zone_height)
	graveyard_zone.position = Vector2(field_width - 150, 50)
	graveyard_zone.color = Color(0.3, 0.3, 0.3, 0.3)
	add_child(graveyard_zone)
	
	var graveyard_label = Label.new()
	graveyard_label.text = "墓地"
	graveyard_label.position = Vector2(field_width - 150, 30)
	add_child(graveyard_label)
	
	# 创建除外区域
	banished_zone = ColorRect.new()
	banished_zone.size = Vector2(zone_width, zone_height)
	banished_zone.position = Vector2(field_width - 250, 50)
	banished_zone.color = Color(0.8, 0.8, 0.8, 0.3)
	add_child(banished_zone)
	
	var banished_label = Label.new()
	banished_label.text = "除外区"
	banished_label.position = Vector2(field_width - 250, 30)
	add_child(banished_label)

# 窗口大小变化时调整UI
func _on_window_resized():
	var viewport_size = get_viewport_rect().size
	size = Vector2(viewport_size.x, viewport_size.y * 0.6)

# 更新场地显示
func update_field():
	# 获取视口大小
	var viewport_size = get_viewport_rect().size
	var field_width = viewport_size.x
	var field_height = viewport_size.y * 0.6
	
	# 更新主要怪兽区域
	for i in range(min(main_monster_zones.size(), player.field.front_row.size())):
		var zone = main_monster_zones[i]
		var card = player.field.front_row[i]
		if card != null:
			zone.color = Color(0.8, 0.2, 0.2, 0.7)  # 有卡时显示红色
		else:
			zone.color = Color(0.5, 0.5, 0.5, 0.3)  # 无卡时显示灰色
	
	# 更新额外怪兽区域
	if player.field.extra_zone != null:
		extra_monster_zone.color = Color(1.0, 0.5, 0.5, 0.7)  # 有卡时显示粉红色
	else:
		extra_monster_zone.color = Color(1.0, 0.5, 0.5, 0.3)  # 无卡时显示浅粉红色
	
	# 更新魔法陷阱区域
	for i in range(min(spell_trap_zones.size(), player.field.back_row.size())):
		var zone = spell_trap_zones[i]
		var card = player.field.back_row[i]
		if card != null:
			zone.color = Color(0.2, 0.2, 0.8, 0.7)  # 有卡时显示蓝色
		else:
			zone.color = Color(0.5, 0.5, 1.0, 0.3)  # 无卡时显示浅蓝色
	
	# 更新卡组区域
	if player.deck.size() > 0:
		deck_zone.color = Color(0.8, 0.8, 0.2, 0.7)  # 有卡时显示黄色
	else:
		deck_zone.color = Color(0.8, 0.8, 0.2, 0.3)  # 无卡时显示浅黄色
	
	# 更新额外卡组区域
	if player.extra_deck.size() > 0:
		extra_deck_zone.color = Color(1.0, 0.5, 0.0, 0.7)  # 有卡时显示橙色
	else:
		extra_deck_zone.color = Color(1.0, 0.5, 0.0, 0.3)  # 无卡时显示浅橙色
	
	# 更新墓地区域
	if player.graveyard.size() > 0:
		graveyard_zone.color = Color(0.3, 0.3, 0.3, 0.7)  # 有卡时显示深灰色
	else:
		graveyard_zone.color = Color(0.3, 0.3, 0.3, 0.3)  # 无卡时显示浅灰色
	
	# 更新除外区域
	if player.banished.size() > 0:
		banished_zone.color = Color(0.8, 0.8, 0.8, 0.7)  # 有卡时显示白色
	else:
		banished_zone.color = Color(0.8, 0.8, 0.8, 0.3)  # 无卡时显示浅灰色