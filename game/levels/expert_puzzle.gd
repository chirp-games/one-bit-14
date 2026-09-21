extends "res://game/levels/nologic_level.gd"


func _on_button_2_pushed() -> void:
	%BoxDoor3.open()


func _on_button_2_released() -> void:
	%BoxDoor3.close()


func _on_button_pushed() -> void:
	%FinalDoor.close()
	%BoxDoor1.open()
	%BoxDoor2.close()
	%PenultimateDoor.open()


func _on_button_released() -> void:
	%FinalDoor.open()
	%BoxDoor1.close()
	%BoxDoor2.open()
	%PenultimateDoor.close()


func _on_completion_area_level_complete() -> void:
	pass # Replace with function body.
