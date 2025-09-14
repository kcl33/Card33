class_name StatsManager
extends Node

var games_played: int = 0
var games_won: int = 0
var total_playtime: int = 0  # 秒
var cards_played: int = 0
var battles_won: int = 0
var highest_damage_dealt: int = 0
var fastest_victory: int = 0  # 回合数

var play_timer: Timer

func _ready():
	setup_timer()

func setup_timer():
	play_timer = Timer.new()
	play_timer.wait_time = 1.0  # 每秒更新一次
	play_timer.autostart = true
	play_timer.connect("timeout", self, "_on_timer_timeout")
	add_child(play_timer)

func _on_timer_timeout():
	total_playtime += 1

func record_game_result(won: bool):
	games_played += 1
	if won:
		games_won += 1

func record_card_played():
	cards_played += 1

func record_battle_won():
	battles_won += 1

func record_damage_dealt(damage: int):
	if damage > highest_damage_dealt:
		highest_damage_dealt = damage

func record_victory_turns(turns: int):
	if fastest_victory == 0 or turns < fastest_victory:
		fastest_victory = turns

func get_win_rate() -> float:
	if games_played == 0:
		return 0.0
	return float(games_won) / float(games_played) * 100.0

func get_playtime_string() -> String:
	var hours = total_playtime / 3600
	var minutes = (total_playtime % 3600) / 60
	var seconds = total_playtime % 60
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

func reset_stats():
	games_played = 0
	games_won = 0
	total_playtime = 0
	cards_played = 0
	battles_won = 0
	highest_damage_dealt = 0
	fastest_victory = 0