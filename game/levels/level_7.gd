extends "res://game/levels/nologic_level.gd"


func _on_button_pushed() -> void:
	print("pushed")
	%Door1.close()
	%Door2.open()


func _on_button_released() -> void:
	print("released")
	%Door1.open()
	%Door2.close()
