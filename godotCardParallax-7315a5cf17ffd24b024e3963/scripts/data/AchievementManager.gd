class_name AchievementManager
extends Node

signal achievement_unlocked(achievement)

var achievements: Dictionary = {
	"first_win": {
		"name": "首场胜利",
		"description": "赢得你的第一场对战",
		"unlocked": false,
		"condition": "win_game"
	},
	"tutorial_complete": {
		"name": "学徒毕业",
		"description": "完成教程",
		"unlocked": false,
		"condition": "complete_tutorial"
	},
	"ten_games": {
		"name": "经验战士",
		"description": "进行10场对战",
		"unlocked": false,
		"condition": "play_games"
	},
	"first_character": {
		"name": "角色收集者",
		"description": "解锁第二个角色",
		"unlocked": false,
		"condition": "unlock_character"
	}
}

func _ready():
	pass

func check_achievement(condition: String, value = null):
	for achievement_id in achievements:
		var achievement = achievements[achievement_id]
		if not achievement.unlocked and achievement.condition == condition:
			var unlocked = false
			
			match condition:
				"win_game":
					unlocked = true
				"complete_tutorial":
					unlocked = true
				"play_games":
					if value >= 10:
						unlocked = true
				"unlock_character":
					unlocked = true
			
			if unlocked:
				unlock_achievement(achievement_id)

func unlock_achievement(achievement_id: String):
	if achievements.has(achievement_id) and not achievements[achievement_id].unlocked:
		achievements[achievement_id].unlocked = true
		emit_signal("achievement_unlocked", achievements[achievement_id])
		print("成就解锁: %s" % achievements[achievement_id].name)

func get_unlocked_achievements() -> Array:
	var unlocked = []
	for achievement_id in achievements:
		if achievements[achievement_id].unlocked:
			unlocked.append(achievements[achievement_id])
	return unlocked

func get_locked_achievements() -> Array:
	var locked = []
	for achievement_id in achievements:
		if not achievements[achievement_id].unlocked:
			locked.append(achievements[achievement_id])
	return locked