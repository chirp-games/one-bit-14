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
var normal_levels: Array[String] = []
var current_level: LevelInfo

func load_levels() -> void:
	var unsorted_levels: Array[LevelInfo] = []
	for file in DirAccess.open("res://resources/levels").get_files():
		unsorted_levels.push_back(load_asset("res://resources/levels/%s" % file))
	
	var loading
	var insert_at 
	while len(unsorted_levels) > 0:
		print(unsorted_levels)
		loading = unsorted_levels[0]
		insert_at = 0
		while loading.next and loading.next not in levels:
			if not loading.challenge:
				normal_levels.push_back(loading.name)
			unsorted_levels.erase(loading)
			levels.insert(insert_at, loading)
			insert_at += 1
			loading = loading.next
		unsorted_levels.erase(loading)
		levels.insert(insert_at, loading)

func next_level() -> LevelInfo:
	current_level = current_level.next
	return current_level

func level_complete() -> void:
	if Engine.is_editor_hint(): # Progress disabled in editor
		return

	var current_unlocks: Array = ConfigManager.get_value("unlocks", [])
	if current_level.unlocks_normal:
		for level in levels:
			if level.name in current_unlocks or level.challenge:
				continue
			current_unlocks.push_back(level.name)
	ConfigManager.set_value("unlocks", current_unlocks)
	
	var current_completions: Array = ConfigManager.get_value("completions", [])
	if current_level.name not in current_completions:
		current_completions.push_back(current_level.name)
		ConfigManager.set_value("completions", current_completions)
	
	for level_name in normal_levels:
		if level_name not in current_completions:
			ConfigManager.on_quit() # Saves progress
			return
		
	for level in levels:
		if level.challenge:
			current_unlocks.push_back(level.name)
	
	ConfigManager.set_value("unlocks", current_unlocks)
	ConfigManager.on_quit()

func reset_unlocks() -> void:
	if Engine.is_editor_hint():
		return
	var unlocks = []
	for level in levels:
		if level.starts_unlocked:
			unlocks.push_back(level.name)
	ConfigManager.set_value("unlocks", unlocks)
	ConfigManager.set_value("completions", [])

func level_unlocked(level: String) -> bool:
	return level in ConfigManager.get_value("unlocks", [])

func unlock_all() -> void:
	ConfigManager.set_value("unlocks", levels.map(func(level): return level.name))

func _ready() -> void:
	load_levels()
	if Engine.is_editor_hint():
		return
	var current_unlocks: Array = ConfigManager.get_value("unlocks", [])
	if current_unlocks == []:
		reset_unlocks()
