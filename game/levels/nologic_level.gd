extends Node3D

signal level_complete

func on_complete() -> void:
	level_complete.emit()

func _on_button_pushed() -> void:
	%Door2.open()
	for w in %Wires2.get_children():
		w.power_on()

func _on_button_released() -> void:
	%Door2.close()
	for w in %Wires2.get_children():
		w.power_off()

func _on_laser_reciever_pushed() -> void:
	%Door.close()
	for w in %Wires.get_children():
		w.power_on()

func _on_laser_reciever_released() -> void:
	%Door.open()
	for w in %Wires.get_children():
		w.power_off()
