extends Node3D

signal level_complete

func on_complete() -> void:
	level_complete.emit()


func _on_button_1_pushed() -> void:
	%Door1.open()


func _on_button_1_released() -> void:
	%Door1.close()


func _on_button_2_pushed() -> void:
	%Door2.open()


func _on_button_2_released() -> void:
	%Door2.close()


func _on_button_3_pushed() -> void:
	%Door3.open()


func _on_button_3_released() -> void:
	%Door3.close()
