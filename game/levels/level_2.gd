extends "res://game/levels/nologic_level.gd"


func _on_button_1_pushed() -> void:
	%WallMountedLaserGun.turn_off()
	%WallMountedLaserGun2.turn_off()
	%WallMountedLaserGun3.turn_off()
	for c in %Wires.get_children():
		c.power_on()


func _on_button_1_released() -> void:
	%WallMountedLaserGun.turn_on()
	%WallMountedLaserGun2.turn_on()
	%WallMountedLaserGun3.turn_on()
	for c in %Wires.get_children():
		c.power_off()
