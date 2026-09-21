extends Node3D

func power_on():
	for w in get_children():
		w.power_on()

func power_off():
	for w in get_children():
		w.power_off()
