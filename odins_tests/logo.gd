extends Node2D


func _ready() -> void:
	await get_tree().create_timer(10).timeout
	%VP.get_texture().get_image().save_png("res://odins_tests/logo.png")
