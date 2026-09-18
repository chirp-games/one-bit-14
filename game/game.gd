@tool
extends Control

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
var current_level: LevelInfo

func load_levels() -> void:
	for file in DirAccess.open("res://resources/levels").get_files():
		levels.push_back(load_asset("res://resources/levels/%s" % file))
	levels.sort_custom(func(_i, x: LevelInfo): return x.number)

func place_level(level: int) -> void:
	var found = levels.find_custom(func(x: LevelInfo): return x.number == level)
	if found < 0 or found >= len(levels):
		push_error("Requested level (%d) not found" % level)
		return
	current_level = levels[found]
	reset()

func reset() -> void:
	for child in %LevelContainer.get_children():
		child.queue_free()
	var new_scene = current_level.scene.instantiate()
	%LevelContainer.add_child(new_scene)
	
	if new_scene.has_signal("level_complete"):
		new_scene.level_complete.connect(func(): place_level(current_level.number + 1))
	else:
		push_warning("Level %s has no level_complete signal." % current_level.name)
	
	%Player.linear_velocity = Vector3.ZERO
	%Player.angular_velocity = Vector3.ZERO
	%Player.global_position = current_level.start_position
	%Player.get_node("%Mesh").global_rotation_degrees = current_level.start_rotation
	%Player.get_node("%Camera").rotation = Vector3.ZERO
	%Player.reset_physics_interpolation()

	%BlackHole.global_position = Vector3(0, -10000, 0)

func _ready() -> void:
	load_levels()
	place_level(11)

func _on_player_create_black_hole(pos: Vector3) -> void:
	%BlackHole.global_position = pos

func _on_player_delete_black_hole() -> void:
	%BlackHole.global_position = Vector3(0, -10000, 0)

func _physics_process(delta: float) -> void:
	if %Player.position.y < -5:
		reset()
