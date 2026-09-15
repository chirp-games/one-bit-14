@tool

extends Control

func _ready() -> void:
	%DitherViewport.texture = %Player.dither_viewport.get_texture()
	$PostProcess.material.set_shader_parameter("outline_tex", %Player.outline_viewport.get_texture())

func _on_player_create_black_hole(pos: Vector3) -> void:
	%BlackHole.global_position = pos
