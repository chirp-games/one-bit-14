extends Node3D

func _ready() -> void:
	for c in %Wires1.get_children():
		c.power_on()
	for c in %Wires2.get_children():
		c.power_on()
	 
func _on_laser_reciever_1_pushed() -> void:
	for c in %Wall1.get_children():
		c.turn_on()
	for c in %Wires1.get_children():
		c.powered = true


func _on_laser_reciever_1_released() -> void:
	for c in %Wall1.get_children():
		c.turn_off()
	for c in %Wires1.get_children():
		c.powered = false

func _on_laser_reciever_2_pushed() -> void:
	for c in %Wall2.get_children():
		c.turn_on()
	for c in %Wires2.get_children():
		c.powered = true


func _on_laser_reciever_2_released() -> void:
	for c in %Wall2.get_children():
		c.turn_off()
	for c in %Wires2.get_children():
		c.powered = false



func _on_button_2_pushed() -> void:
	%Door.open()


func _on_button_2_released() -> void:
	%Door.close()
