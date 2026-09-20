extends Node3D

signal level_complete

func on_complete() -> void:
	level_complete.emit()


func _on_button_1_pushed() -> void:
	%Door1.open()


func _on_button_1_released() -> void:
	%Door1.close()
