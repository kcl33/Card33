extends Node2D

# 抽卡动画控制器
signal card_drawn(card)

var deck_visual = null
var hand_visual = null
var card_tween = null
var is_drawing = false

func _ready():
	pass

# 初始化抽卡动画
func initialize(deck_pos, hand_pos):
	deck_visual = Node2D.new()
	deck_visual.position = deck_pos
	add_child(deck_visual)
	
	hand_visual = Node2D.new()
	hand_visual.position = hand_pos
	add_child(hand_visual)

# 执行抽卡动画
func draw_card_animation(card_data):
	if is_drawing:
		return
		
	is_drawing = true
	
	# 创建卡牌可视化对象
	var card_visual = preload("res://scripts/ui/CardVisual.gd").new(card_data)
	card_visual.position = deck_visual.position
	card_visual.scale = Vector2(0.1, 0.1)
	add_child(card_visual)
	
	# 创建动画
	card_tween = create_tween()
	card_tween.set_parallel(true)
	
	# 缩放动画
	card_tween.tween_property(card_visual, "scale", Vector2(1, 1), 0.5)
	
	# 移动动画
	card_tween.tween_property(card_visual, "position", hand_visual.position, 0.5)
	
	# 旋转动画
	card_tween.tween_property(card_visual, "rotation", 0, 0.5)
	
	# 完成后发出信号
	await card_tween.finished
	emit_signal("card_drawn", card_data)
	card_visual.queue_free()
	is_drawing = false