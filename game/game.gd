@tool

extends Control

func _ready() -> void:
	%DitherViewport.texture = %Player.dither_viewport.get_texture()
	$PostProcess.material.set_shader_parameter("outline_tex", %Player.outline_viewport.get_texture())
