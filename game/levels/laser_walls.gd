extends Node3D

func _on_button_2_pushed() -> void:
	%Door.open()


func _on_button_2_released() -> void:
	%Door.close()
