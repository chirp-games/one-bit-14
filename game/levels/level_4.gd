extends "res://game/levels/nologic_level.gd"


@onready var box_reset = %Box.global_position

func reset_box() -> void:
	%Box.freeze = true
	var reset = get_tree().create_tween()
	reset.tween_property(%Box, "scale", Vector3.ONE * 0.001, 0.5)
	reset.tween_property(%Box, "global_position", box_reset, 0)
	reset.tween_property(%Box, "scale", Vector3.ONE, 0.5)
	reset.tween_callback(func(): %Box.freeze = false)
