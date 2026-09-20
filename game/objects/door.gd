extends Node3D

@export var is_open = false

func _ready() -> void:
	if is_open:
		%Animations.play("open")

func open():
	if is_open:
		return
	%Animations.play("open")
	$DoorOpen.play()
	is_open = true

func close():
	if not is_open:
		return
	%Animations.play_backwards("open")
	$DoorClose.play()
	is_open = false
