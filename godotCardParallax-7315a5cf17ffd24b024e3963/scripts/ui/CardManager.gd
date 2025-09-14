class_name CardManager
extends Control

signal card_hovered(card)
signal card_unhovered(card)
signal card_clicked(card)

func _ready():
	pass

func create_card_display(card: Card) -> Control:
	var card_display = preload("res://scenes/ui/CardDisplay.tscn").instance()
	card_display.set_card(card)
	
	# 连接输入事件
	card_display.connect("mouse_entered", self, "_on_card_mouse_entered", [card])
	card_display.connect("mouse_exited", self, "_on_card_mouse_exited", [card])
	card_display.connect("gui_input", self, "_on_card_gui_input", [card])
	
	return card_display

func _on_card_mouse_entered(card: Card):
	emit_signal("card_hovered", card)

func _on_card_mouse_exited(card: Card):
	emit_signal("card_unhovered", card)

func _on_card_gui_input(event: InputEvent, card: Card):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("card_clicked", card)

func update_card_display(card_display: Control, card: Card):
	if card_display and card:
		card_display.set_card(card)