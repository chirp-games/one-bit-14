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
	levels.sort_custom(func(x: LevelInfo): return x.number)

func place_level(level: int) -> void:
	current_level = levels[levels.find_custom(func(x: LevelInfo): return x.number == level)]
	reset()

func reset() -> void:
	for child in %LevelContainer.get_children():
		child.queue_free()
	%LevelContainer.add_child(current_level.scene.instantiate())
	
	%Player.linear_velocity = Vector3.ZERO
	%Player.angular_velocity = Vector3.ZERO
	%Player.global_position = current_level.start_position
	%Player.get_node("%Mesh").global_rotation_degrees = current_level.start_rotation
	%Player.reset_physics_interpolation()
	
	%BlackHole.global_position = Vector3(0, -10000, 0)

func _ready() -> void:
	%DitherViewport.texture = %Player.dither_viewport.get_texture()
	$PostProcess.material.set_shader_parameter("outline_tex", %Player.outline_viewport.get_texture())
	
	load_levels()
	place_level(1)

func _on_player_create_black_hole(pos: Vector3) -> void:
	%BlackHole.global_position = pos

func _on_player_delete_black_hole() -> void:
	%BlackHole.global_position = Vector3(0, -10000, 0)
