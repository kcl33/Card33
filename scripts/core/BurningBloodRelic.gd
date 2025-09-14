extends "res://scripts/core/Relic.gd"

# 燃烧之血遗物 - 每回合结束时回复2点生命值

func _init():
	# 调用父类初始化
	# 设置遗物属性
	self.id = "burning_blood"
	self.relic_name = "燃烧之血"
	self.description = "在每个回合结束时回复2点生命值"
	self.relic_type = self.RelicType.COMMON
	self.rarity = self.Rarity.COMMON
	self.trigger_timing = [self.TriggerTiming.TURN_END]

# 激活遗物效果
func activate(player):
	self.is_active = true
	print("激活遗物: ", self.relic_name)

# 触发遗物效果
func trigger(player, context=null):
	if not self.is_active:
		return
	
	# 回合结束时回复2点生命值
	player.life_points += 2
	print("遗物 [", self.relic_name, "] 发动效果: 回复2点生命值，当前生命值: ", player.life_points)