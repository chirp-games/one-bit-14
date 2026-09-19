@tool
extends Control


func place_next_level() -> void:
	place_level(LevelManager.next_level())

func loop_music() -> void:
	$BGM.play()
	await get_tree().create_timer($BGM.stream.get_length()).timeout
	loop_music()

func place_level(level: LevelInfo) -> void:
	LevelManager.current_number = level.number
	reset()

func reset() -> void:
	for child in %LevelContainer.get_children():
		child.queue_free()
	var new_scene = LevelManager.current_level.scene.instantiate()
	%LevelContainer.add_child(new_scene)
	
	if new_scene.has_signal("level_complete"):
		new_scene.level_complete.connect(place_next_level)
	else:
		push_warning("Level '%s' has no level_complete signal." % LevelManager.current_level.name)
	
	%Player.linear_velocity = Vector3.ZERO
	%Player.angular_velocity = Vector3.ZERO
	%Player.global_position = LevelManager.current_level.start_position
	%Player.get_node("%Mesh").global_rotation_degrees = LevelManager.current_level.start_rotation
	%Player.get_node("%Camera").rotation = Vector3.ZERO
	%Player.reset_physics_interpolation()

	%BlackHole.global_position = Vector3(0, -10000, 0)

func _ready() -> void:
	load_levels()
	place_level(1)
	reset()
	if not Engine.is_editor_hint():
		loop_music()

func _on_player_create_black_hole(pos: Vector3) -> void:
	%BlackHole.global_position = pos

func _on_player_delete_black_hole() -> void:
	%BlackHole.global_position = Vector3(0, -10000, 0)

func _physics_process(_delta: float) -> void:
	if %Player.position.y < (LevelManager.current_level.floor if LevelManager.current_level else -5):
		reset()
		%Player
func _process(delta: float) -> void:
	if %BlackHole.global_position != null:
		var viewport = %Player.get_viewport()
		print(%Player.get_viewport().get_camera_3d().unproject_position(%BlackHole.global_position))
		var black_hole_pos = viewport.get_camera_3d().unproject_position(%BlackHole.global_position)
		$SubViewportContainer.material.set_shader_parameter("black_hole_location", Vector4(black_hole_pos.x,black_hole_pos.y,%Player.global_position.distance_to(%BlackHole.global_position),0. if viewport.get_camera_3d().is_position_behind(%BlackHole.global_position) else 1.))
