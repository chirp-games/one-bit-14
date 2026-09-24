extends Control


func reset() -> void:
	for child in %LevelContainer.get_children():
		child.queue_free()
	var new_scene = LevelManager.current_level.scene.instantiate()
	%LevelContainer.add_child(new_scene)
	
	if new_scene.has_signal("level_complete"):
		pass
	else:
		push_warning("Level '%s' has no level_complete signal." % LevelManager.current_level.name)

func _ready() -> void:
	reset()
