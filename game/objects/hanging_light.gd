@tool

extends Node3D

@export var length = 3:
	set(v):
		if not is_node_ready():
			return
		length = v
		%Bulb.position = -length
		%String.mesh.size.y = length - .5
		%String.position.y = length / 2.
	get():
		return length

func _ready() -> void:
	%String.mesh.size.y = length - .5
	%String.position.y = length / 2.
	%Bulb.position.y = -length
