<<<<<<< HEAD
extends Node3D
=======
@tool

extends Node3D

@export var length: float = 3.0

func _enter_tree() -> void:
	%String.mesh = %String.mesh.duplicate()
	
	%Bulb.position.y = -length
	%String.mesh.size.y = length
	%String.position.y = length / 2.
>>>>>>> d61e04ae67e6687eaacc560659c880dd8f293521
