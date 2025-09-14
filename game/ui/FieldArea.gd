extends Control

var player = null
var field_visuals = []
var monster_zones = []
var spell_zones = []

func _init(player_obj):
	player = player_obj
	size = Vector2(800, 200)
	position = Vector2(0, 300)
	
	# 初始化区域
	initialize_zones()

# 初始化区域
func initialize_zones():
	# 创建5个怪兽区域
	for i in range(5):
		var zone = ColorRect.new()
		zone.color = Color(0.5, 0.5, 0.5, 0.3)
		zone.size = Vector2(100, 150)
		zone.position = Vector2(i * 120 + 100, 10)
		add_child(zone)
		monster_zones.append(zone)
	
	# 创建5个魔法陷阱区域
	for i in range(5):
		var zone = ColorRect.new()
		zone.color = Color(0.3, 0.3, 0.7, 0.3)
		zone.size = Vector2(100, 50)
		zone.position = Vector2(i * 120 + 100, 170)
		add_child(zone)
		spell_zones.append(zone)

# 更新场上显示
func update_field():
	# 清除现有的卡牌可视化
	for visual in card_visuals:
		visual.queue_free()
	card_visuals.clear()
	
	# 显示前场怪兽
	for i in range(player.field.front_row.size()):
		var monster = player.field.front_row[i]
		if monster != null:
			var card_visual
			# 根据表示形式决定显示正面还是背面
			if monster.position == monster.Position.FACE_DOWN_ATTACK or monster.position == monster.Position.FACE_DOWN_DEFENSE:
				# 里侧表示显示背面
				card_visual = CardVisual.new(null, true)
			else:
				# 表侧表示显示正面
				card_visual = CardVisual.new(monster)
			
			card_visual.position = Vector2(100 + i * 130, 10)
			add_child(card_visual)
			card_visuals.append(card_visual)
	
	# 显示后场魔法陷阱卡
	for i in range(player.field.back_row.size()):
		var spell = player.field.back_row[i]
		if spell != null:
			var card_visual
			# 魔法陷阱卡默认盖伏
			if spell.is_face_down:
				# 盖伏状态显示背面
				card_visual = CardVisual.new(null, true)
			else:
				# 表侧表示显示正面
				card_visual = CardVisual.new(spell)
			
			card_visual.position = Vector2(100 + i * 130, 100)
			add_child(card_visual)
			card_visuals.append(card_visual)

# 处理输入事件
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			handle_left_click(event)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			handle_right_click(event)

# 处理左键点击
func handle_left_click(event):
	var click_position = event.position
	for card_visual in field_visuals:
		if card_visual.get_rect().has_point(card_visual.get_local_mouse_position()):
			# 选择场上的卡牌并显示选项
			print("左键点击场上卡牌: ", card_visual.card_data.card_name)
			card_visual.show_context_menu()
			return

# 处理右键点击
func handle_right_click(event):
	var click_position = event.position
	for card_visual in field_visuals:
		if card_visual.get_rect().has_point(card_visual.get_local_mouse_position()):
			# 选择场上的卡牌并显示选项
			print("右键点击场上卡牌: ", card_visual.card_data.card_name)
			card_visual.show_context_menu()
			return