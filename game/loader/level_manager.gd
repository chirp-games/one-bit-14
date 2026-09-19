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
var current_number: int = 1
var current_level: LevelInfo :
	get():
		return levels[
			levels.find_custom(func(x: LevelInfo): return x.number == current_number)
		]

func load_levels() -> void:
	for file in DirAccess.open("res://resources/levels").get_files():
		levels.push_back(load_asset("res://resources/levels/%s" % file))
	levels.sort_custom(func(a:LevelInfo, b:LevelInfo): return a.number < b.number)

func next_level() -> LevelInfo:
	current_number += 1
	return current_level

func _ready() -> void:
	load_levels()
