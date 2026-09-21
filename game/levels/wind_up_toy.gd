extends "res://game/levels/nologic_level.gd"


func _on_button_pushed() -> void:
	%Door1.close()
	%Door2.open()
	%Wires.power_on()


func _on_button_released() -> void:
	%Door1.open()
	%Door2.close()
	%Wires.power_off()


func _on_completion_area_level_complete() -> void:
	on_complete()
