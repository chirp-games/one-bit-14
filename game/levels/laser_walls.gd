extends Node3D


func _on_laser_reciever_1_pushed() -> void:
	%A1.turn_on()
	%A2.turn_on()
	%A3.turn_on()
	%A4.turn_on()
	%A5.turn_on()
	%A6.turn_on()
	%A7.turn_on()


func _on_laser_reciever_1_released() -> void:
	%A1.turn_off()
	%A2.turn_off()
	%A3.turn_off()
	%A4.turn_off()
	%A5.turn_off()
	%A6.turn_off()
	%A7.turn_off()


func _on_laser_reciever_2_pushed() -> void:
	%B1.turn_on()
	%B2.turn_on()
	%B3.turn_on()
	%B4.turn_on()
	%B5.turn_on()
	%B6.turn_on()
	%B7.turn_on()

func _on_laser_reciever_2_released() -> void:
	%B1.turn_off()
	%B2.turn_off()
	%B3.turn_off()
	%B4.turn_off()
	%B5.turn_off()
	%B6.turn_off()
	%B7.turn_off()


func _on_button_2_pushed() -> void:
	%Door.open()


func _on_button_2_released() -> void:
	%Door.close()
