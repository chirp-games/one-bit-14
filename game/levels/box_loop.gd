extends "res://game/levels/nologic_level.gd"


func _on_button_1_pushed() -> void:
	%Door1.open()
	for w in %Wires1.get_children():
		w.power_on()

func _on_button_1_released() -> void:
	%Door1.close()
	for w in %Wires1.get_children():
		w.power_off()

func _on_completion_area_level_complete() -> void:
	on_complete()


func _on_button_2_pushed() -> void:
	%Door2.open()
	for w in %Wires2.get_children():
		w.power_on()

func _on_button_2_released() -> void:
	%Door2.close()
	for w in %Wires2.get_children():
		w.power_off()
