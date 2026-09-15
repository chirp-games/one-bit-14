extends Node3D


func _on_button_1_pushed() -> void:
	print("pushed")
	%PathPlatform.movement_mode = PathFollowPlatform.MovementMode.Forward
	%Door.open()

func _on_button_1_released() -> void:
	print("released")
	%PathPlatform.movement_mode = PathFollowPlatform.MovementMode.Back
	%Door.close()
