@tool

extends Control

func _ready() -> void:
	%DitherViewport.texture = %Player.dither_viewport.get_texture()
	%OutlineViewport.texture = %Player.outline_viewport.get_texture()
