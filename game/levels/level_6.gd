extends "res://game/levels/nologic_level.gd"

func _process(_delta: float) -> void:
	pass


func _on_laser_reciever_pushed() -> void:
	%Door.close()


func _on_laser_reciever_released() -> void:
	%Door.open()


func _on_completion_area_level_complete() -> void:
	on_complete()
