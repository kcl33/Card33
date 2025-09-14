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
	var card_visual = CardVisual.new(card_data)
	card_visual.position = deck_visual.position
	card_visual.scale = Vector2(0.1, 0.1)
	add_child(card_visual)
	
	# 创建动画
	card_tween = create_tween()
	card_tween.set_parallel(true)
	
	# 缩放动画
	card_tween.tween_property(card_visual, "scale", Vector2(1, 1), 0.3)
	
	# 移动动画：从牌堆到手牌区域
	card_tween.tween_property(card_visual, "position", hand_visual.position, 0.5)
	
	# 连接动画完成信号
	card_tween.tween_callback(Callable(self, "_on_draw_animation_finished").bind(card_visual, card_data))

# 动画完成回调
func _on_draw_animation_finished(card_visual, card_data):
	emit_signal("card_drawn", card_data)
	card_visual.queue_free()
	is_drawing = false
