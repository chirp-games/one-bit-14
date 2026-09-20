@tool
extends Node


## https://www.reddit.com/r/godot/comments/13u9w0j/comment/ldb4q0w
static func load_asset(path : String) -> Resource:
	if OS.has_feature("export"):
		# Check if file is .remap
		if not path.ends_with(".remap"):
			return load(path)

		# Open the file
		var __config_file = ConfigFile.new()
		__config_file.load(path)

		# Load the remapped file
		var __remapped_file_path = __config_file.get_value("remap", "path")
		__config_file = null
		return load(__remapped_file_path)
	else:
		return load(path)

var levels: Array[LevelInfo] = []
var normal_level_numbers: Array[int] = []
var current_number: int = 1
var current_level: LevelInfo :
	get():
		var level_index = levels.find_custom(func(x: LevelInfo): return x.number == current_number)
		return levels[level_index] if level_index >= 0 else null

func load_levels() -> void:
	for file in DirAccess.open("res://resources/levels").get_files():
		levels.push_back(load_asset("res://resources/levels/%s" % file))
	levels.sort_custom(func(a:LevelInfo, b:LevelInfo): return a.number < b.number)
	for level in levels:
		if not level.challenge:
			normal_level_numbers.push_back(level.number)

func next_level() -> LevelInfo:
	current_number += 1
	return current_level

func level_complete() -> void:
	if Engine.is_editor_hint(): # Progress disabled in editor
		return

	var current_unlocks: Array = ConfigManager.get_value("unlocks", [])
	current_unlocks.append_array(current_level.unlocks)
	ConfigManager.set_value("unlocks", current_unlocks)
	
	var current_completions: Array = ConfigManager.get_value("completions", [])
	current_completions.push_back(current_level.number)
	ConfigManager.set_value("completions", current_completions)
	
	ConfigManager.on_quit() # Saves progress
	
	for level_number in normal_level_numbers:
		if level_number not in current_completions:
			return
	for level in levels:
		if level.challenge:
			current_unlocks.push_back(level.number)
	ConfigManager.set_value("unlocks", current_unlocks)
	ConfigManager.on_quit()

func reset_unlocks() -> void:
	if Engine.is_editor_hint():
		return
	var unlocks = []
	for level in levels:
		if level.starts_unlocked:
			unlocks.push_back(level.number)
	ConfigManager.set_value("unlocks", unlocks)
	ConfigManager.set_value("completions", [])

func level_unlocked(level: int) -> bool:
	return level in ConfigManager.get_value("unlocks", [])

func unlock_all() -> void:
	ConfigManager.set_value("unlocks", levels.map(func(level): return level.number))

func _ready() -> void:
	load_levels()
	if Engine.is_editor_hint():
		return
	var current_unlocks: Array = ConfigManager.get_value("unlocks", [])
	if current_unlocks == []:
		reset_unlocks()
