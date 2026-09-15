extends Area3D


signal level_complete

func on_object_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	
	level_complete.emit()
