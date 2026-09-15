extends Node3D

func _ready() -> void:
	%Animations.play_backwards("open")


func open():
	%Animations.play("open")

func close():
	%Animations.play_backwards("open")
