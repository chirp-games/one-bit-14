extends "res://game/levels/nologic_level.gd"

func _process(_delta: float) -> void:
	if not (%Button.is_pushed or %Button2.is_pushed):
		%Door.open()
	else:
		%Door.close()


func _on_button_pushed() -> void:
	print("pushed 1")


func _on_button_2_pushed() -> void:
	print("pushed 2")
