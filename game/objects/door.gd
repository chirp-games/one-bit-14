extends Node3D

@export var is_open = false

func _ready() -> void:
	if is_open:
		%Animations.play("open")
	else:
		%Animations.play_backwards("open")

func open():
	if is_open:
		return
	%Animations.play("open")
	is_open = true

func close():
	if not is_open:
		return
	%Animations.play_backwards("open")
	is_open = false
