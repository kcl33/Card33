class_name HandManager
extends HBoxContainer

var cards: Array = []
var card_scenes: Array = []

signal card_selected(card)
signal card_played(card)

func _ready():
	pass

func setup_hand(player: Player):
	clear_hand()
	
	# 为手牌中的每张卡创建显示对象
	for card in player.hand:
		add_card(card)

func clear_hand():
	# 清除现有的手牌显示
	for card_scene in card_scenes:
		card_scene.queue_free()
	card_scenes.clear()
	cards.clear()

func add_card(card: Card):
	cards.append(card)
	
	# 创建卡牌显示对象
	var card_display = preload("res://scenes/ui/CardDisplay.tscn").instance()
	card_display.set_card(card)
	
	# 连接卡牌点击信号
	card_display.connect("gui_input", self, "_on_card_gui_input", [card])
	
	# 添加到容器
	add_child(card_display)
	card_scenes.append(card_display)

func remove_card(card: Card):
	var index = cards.find(card)
	if index != -1:
		cards.remove(index)
		if index < card_scenes.size():
			var card_scene = card_scenes[index]
			card_scenes.remove(index)
			card_scene.queue_free()

func _on_card_gui_input(event: InputEvent, card: Card):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		# 选择卡牌
		emit_signal("card_selected", card)
		
		# 如果是右键点击，则尝试打出卡牌
		if event.button_index == BUTTON_RIGHT:
			emit_signal("card_played", card)

func highlight_card(card: Card):
	var index = cards.find(card)
	if index != -1 and index < card_scenes.size():
		card_scenes[index].highlight()

func unhighlight_card(card: Card):
	var index = cards.find(card)
	if index != -1 and index < card_scenes.size():
		card_scenes[index].unhighlight()

func update_hand(player: Player):
	# 更新手牌显示
	clear_hand()
	setup_hand(player)