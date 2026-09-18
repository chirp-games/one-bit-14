extends "res://game/levels/nologic_level.gd"


func _on_button_pushed() -> void:
	print("pushed")
	%Door1.close()
	%Door2.open()
	
	for w in $Wires1.get_children():
		w.power_on()
	for w in $Wires2.get_children():
		w.power_on()

func _on_button_released() -> void:
	print("released")
	%Door1.open()
	%Door2.close()

	for w in $Wires1.get_children():
		w.power_off()
	for w in $Wires2.get_children():
		w.power_off()


func _on_completion_area_level_complete() -> void:
	on_complete()
