@tool
extends Control


func place_next_level() -> void:
	LevelManager.level_complete()
	var next_level := LevelManager.next_level()
	if next_level and LevelManager.level_unlocked(next_level.number):
		place_level(next_level)
	else:
		main_menu()

func loop_music() -> void:
	$BGM.play()
	await get_tree().create_timer($BGM.stream.get_length()).timeout
	loop_music()

func audio_sync(audio: AudioStreamPlayer3D) -> void:
	audio.play($BGM.get_playback_position() + AudioServer.get_time_since_last_mix())

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

func main_menu() -> void:
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://game/loader/picker.tscn")

func pause() -> void:
	get_tree().paused = true
	%PauseMenu.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func unpause() -> void:
	get_tree().paused = false
	%PauseMenu.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready() -> void:
	if not Engine.is_editor_hint():
		loop_music()
	
	if not OS.has_feature("web"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	reset()

func _on_player_create_black_hole(pos: Vector3) -> void:
	%BlackHole.global_position = pos

func _on_player_delete_black_hole() -> void:
	%BlackHole.global_position = Vector3(0, -10000, 0)

func _physics_process(_delta: float) -> void:
	if %Player.position.y < (LevelManager.current_level.floor if LevelManager.current_level else -5):
		reset()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			unpause()
		else:
			pause()
	
	if %BlackHole.global_position != null:
		var viewport = %Player.get_viewport()
		var p = %BlackHole.global_position
		p.y = 0
		var black_hole_pos := Vector2.ZERO
		if p != Vector3.ZERO:
			black_hole_pos = viewport.get_camera_3d().unproject_position(%BlackHole.global_position)
		$SubViewportContainer.material.set_shader_parameter("black_hole_location", Vector4(black_hole_pos.x,black_hole_pos.y,%Player.global_position.distance_to(%BlackHole.global_position),0. if viewport.get_camera_3d().is_position_behind(%BlackHole.global_position) else 1.))
