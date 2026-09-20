extends "res://game/levels/nologic_level.gd"


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


func _on_completion_area_level_complete() -> void:
	on_complete()
