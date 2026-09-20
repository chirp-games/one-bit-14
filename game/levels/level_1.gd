extends "res://game/levels/nologic_level.gd"


func _on_button_1_pushed() -> void:
	%Door1.open()
	%wire1.power_on()
	%wire2.power_on()


func _on_button_1_released() -> void:
	%Door1.close()
	%wire1.power_off()
	%wire2.power_off()

func _on_completion_area_level_complete() -> void:
	on_complete()
