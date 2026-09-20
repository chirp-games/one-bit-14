extends "res://game/levels/nologic_level.gd"

func _on_button_2_pushed() -> void:
	%Door.open()


func _on_button_2_released() -> void:
	%Door.close()
