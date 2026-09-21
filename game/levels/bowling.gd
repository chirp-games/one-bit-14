extends "res://game/levels/nologic_level.gd"


func _on_laser_reciever_pushed() -> void:
	for w in %Wires.get_children():
		w.power_on()
	%Door.open()


func _on_laser_reciever_released() -> void:
	for w in %Wires.get_children():
		w.power_off()
	%Door.close()


func _on_completion_area_level_complete() -> void:
	on_complete()
