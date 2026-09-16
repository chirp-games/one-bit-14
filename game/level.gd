extends Node3D

signal level_complete

func on_complete() -> void:
	level_complete.emit()

func recieve_laser() -> void:
	print("DING - Got laser")
	
func lose_laser() -> void:
	print("Lost laser :(")

func _ready() -> void:
	%Door.open()

func _on_button_1_pushed() -> void:
	print("pushed")
	%PathPlatform.movement_mode = PathFollowPlatform.MovementMode.Forward
	%Door.close()

func _on_button_1_released() -> void:
	print("released")
	%PathPlatform.movement_mode = PathFollowPlatform.MovementMode.Back
	%Door.open()
