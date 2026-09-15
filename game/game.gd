@tool

extends Control

func _ready() -> void:
	%DitherViewport.texture = %Player.dither_viewport.get_texture()
	%OutlineViewport.texture = %Player.outline_viewport.get_texture()

func _on_player_create_black_hole(pos: Vector3) -> void:
	%BlackHole.global_position = pos
