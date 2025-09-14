class_name SaveManager
extends Node

const SAVE_FILE_PATH = "user://savegame.save"
const SETTINGS_FILE_PATH = "user://settings.save"

# 存档数据结构
var save_data = {
	"version": "1.0",
	"player_progress": {
		"story_progress": {},
		"unlocked_characters": [],
		"unlocked_cards": [],
		"unlocked_relics": [],
		"character_levels": {}
	},
	"settings": {
		"music_volume": 1.0,
		"sfx_volume": 1.0,
		"fullscreen": false,
		"language": "zh"
	},
	"statistics": {
		"games_played": 0,
		"games_won": 0,
		"total_playtime": 0,
		"cards_played": 0,
		"battles_won": 0,
		"highest_damage_dealt": 0,
		"fastest_victory": 0
	},
	"achievements": {}
}

func _ready():
	load_settings()

# 存档游戏进度
func save_game(story_manager: StoryManager, achievement_manager: AchievementManager):
	save_data.player_progress.story_progress = story_manager.story_progress.duplicate()
	
	# 保存已解锁的角色、卡牌和遗物
	# 这里应该从游戏系统中获取实际数据
	save_data.player_progress.unlocked_characters = []
	save_data.player_progress.unlocked_cards = []
	save_data.player_progress.unlocked_relics = []
	
	# 保存成就
	save_data.achievements = achievement_manager.achievements.duplicate()
	
	save_to_file(SAVE_FILE_PATH, save_data)

# 加载游戏进度
func load_game(story_manager: StoryManager, achievement_manager: AchievementManager) -> bool:
	var data = load_from_file(SAVE_FILE_PATH)
	if data == null:
		return false
	
	save_data = data
	
	# 应用故事进度
	if save_data.has("player_progress") and save_data.player_progress.has("story_progress"):
		story_manager.story_progress = save_data.player_progress.story_progress.duplicate()
	
	# 应用成就
	if save_data.has("achievements"):
		for achievement_id in save_data.achievements:
			if achievement_manager.achievements.has(achievement_id):
				achievement_manager.achievements[achievement_id].unlocked = save_data.achievements[achievement_id].unlocked
	
	return true

# 保存设置
func save_settings():
	save_to_file(SETTINGS_FILE_PATH, save_data.settings)

# 加载设置
func load_settings():
	var data = load_from_file(SETTINGS_FILE_PATH)
	if data != null and data.has("settings"):
		save_data.settings = data

# 保存统计数据
func save_statistics(stats_manager: StatsManager):
	save_data.statistics.games_played = stats_manager.games_played
	save_data.statistics.games_won = stats_manager.games_won
	save_data.statistics.total_playtime = stats_manager.total_playtime
	save_data.statistics.cards_played = stats_manager.cards_played
	save_data.statistics.battles_won = stats_manager.battles_won
	save_data.statistics.highest_damage_dealt = stats_manager.highest_damage_dealt
	save_data.statistics.fastest_victory = stats_manager.fastest_victory
	
	save_to_file("user://statistics.save", save_data.statistics)

# 加载统计数据
func load_statistics(stats_manager: StatsManager):
	var data = load_from_file("user://statistics.save")
	if data != null:
		stats_manager.games_played = data.get("games_played", 0)
		stats_manager.games_won = data.get("games_won", 0)
		stats_manager.total_playtime = data.get("total_playtime", 0)
		stats_manager.cards_played = data.get("cards_played", 0)
		stats_manager.battles_won = data.get("battles_won", 0)
		stats_manager.highest_damage_dealt = data.get("highest_damage_dealt", 0)
		stats_manager.fastest_victory = data.get("fastest_victory", 0)

# 通用保存到文件方法
func save_to_file(path: String, data):
	var file = File.new()
	var error = file.open(path, File.WRITE)
	if error == OK:
		file.store_line(to_json(data))
		file.close()
		return true
	else:
		push_error("无法保存文件: %s" % path)
		return false

# 通用从文件加载方法
func load_from_file(path: String):
	var file = File.new()
	if file.file_exists(path):
		var error = file.open(path, File.READ)
		if error == OK:
			var data = parse_json(file.get_line())
			file.close()
			return data
		else:
			push_error("无法读取文件: %s" % path)
			return null
	else:
		return null

# 重置存档
func reset_save():
	save_data.player_progress = {
		"story_progress": {},
		"unlocked_characters": [],
		"unlocked_cards": [],
		"unlocked_relics": [],
		"character_levels": {}
	}
	
	save_data.achievements = {}
	
	var dir = Directory.new()
	dir.remove(SAVE_FILE_PATH)