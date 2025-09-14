class_name FieldManager
extends Control

@onready var monster_zones = $MonsterZones
@onready var spell_zones = $SpellZones
@onready var extra_zone = $ExtraZone

var monster_zone_displays: Array = []
var spell_zone_displays: Array = []
var extra_zone_display

signal zone_selected(zone_type, zone_index)

func _ready():
	setup_field()

func setup_field():
	# 设置怪兽区域
	for i in range(5):
		var zone = PanelContainer.new()
		zone.rect_min_size = Vector2(100, 150)
		zone.name = "MonsterZone%d" % (i + 1)
		zone.connect("gui_input", self, "_on_zone_gui_input", ["monster", i])
		
		var label = Label.new()
		label.text = "M%d" % (i + 1)
		label.align = Label.ALIGN_CENTER
		label.valign = Label.VALIGN_CENTER
		zone.add_child(label)
		
		monster_zones.add_child(zone)
		monster_zone_displays.append(zone)
	
	# 设置魔法/陷阱区域
	for i in range(5):
		var zone = PanelContainer.new()
		zone.rect_min_size = Vector2(100, 150)
		zone.name = "SpellZone%d" % (i + 1)
		zone.connect("gui_input", self, "_on_zone_gui_input", ["spell", i])
		
		var label = Label.new()
		label.text = "S%d" % (i + 1)
		label.align = Label.ALIGN_CENTER
		label.valign = Label.VALIGN_CENTER
		zone.add_child(label)
		
		spell_zones.add_child(zone)
		spell_zone_displays.append(zone)
	
	# 设置额外区域
	extra_zone_display = PanelContainer.new()
	extra_zone_display.rect_min_size = Vector2(120, 180)
	extra_zone_display.name = "ExtraZone"
	extra_zone_display.connect("gui_input", self, "_on_zone_gui_input", ["extra", 0])
	
	var label = Label.new()
	label.text = "EXTRA"
	label.align = Label.ALIGN_CENTER
	label.valign = Label.VALIGN_CENTER
	extra_zone_display.add_child(label)
	
	extra_zone.add_child(extra_zone_display)

func update_field(player: Player):
	# 更新怪兽区域
	for i in range(min(player.field_monster_zones.size(), monster_zone_displays.size())):
		var card = player.field_monster_zones[i]
		var zone_display = monster_zone_displays[i]
		
		# 清除区域中的现有内容
		for child in zone_display.get_children():
			if not (child is Label):
				child.queue_free()
		
		# 如果有卡牌，显示卡牌
		if card != null:
			var card_display = preload("res://scenes/ui/CardDisplay.tscn").instance()
			card_display.set_card(card)
			zone_display.add_child(card_display)
	
	# 更新魔法/陷阱区域
	for i in range(min(player.field_spell_zones.size(), spell_zone_displays.size())):
		var card = player.field_spell_zones[i]
		var zone_display = spell_zone_displays[i]
		
		# 清除区域中的现有内容
		for child in zone_display.get_children():
			if not (child is Label):
				child.queue_free()
		
		# 如果有卡牌，显示卡牌
		if card != null:
			var card_display = preload("res://scenes/ui/CardDisplay.tscn").instance()
			card_display.set_card(card)
			zone_display.add_child(card_display)
	
	# 更新额外区域
	var extra_card = player.extra_monster_zone
	# 清除额外区域中的现有内容
	for child in extra_zone_display.get_children():
		if not (child is Label):
			child.queue_free()
	
	# 如果有卡牌，显示卡牌
	if extra_card != null:
		var card_display = preload("res://scenes/ui/CardDisplay.tscn").instance()
		card_display.set_card(extra_card)
		extra_zone_display.add_child(card_display)

func _on_zone_gui_input(event: InputEvent, zone_type: String, zone_index: int):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("zone_selected", zone_type, zone_index)

func highlight_zone(zone_type: String, zone_index: int):
	var zone_display = null
	
	match zone_type:
		"monster":
			if zone_index < monster_zone_displays.size():
				zone_display = monster_zone_displays[zone_index]
		"spell":
			if zone_index < spell_zone_displays.size():
				zone_display = spell_zone_displays[zone_index]
		"extra":
			zone_display = extra_zone_display
	
	if zone_display:
		zone_display.modulate = Color(1.0, 1.0, 0.0, 1.0)  # 黄色高亮

func unhighlight_zone(zone_type: String, zone_index: int):
	var zone_display = null
	
	match zone_type:
		"monster":
			if zone_index < monster_zone_displays.size():
				zone_display = monster_zone_displays[zone_index]
		"spell":
			if zone_index < spell_zone_displays.size():
				zone_display = spell_zone_displays[zone_index]
		"extra":
			zone_display = extra_zone_display
	
	if zone_display:
		zone_display.modulate = Color(1.0, 1.0, 1.0, 1.0)  # 恢复正常颜色