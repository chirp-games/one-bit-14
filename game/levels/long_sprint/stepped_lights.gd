@tool
extends Node3D


@export var lights = 10
@export var step = Vector3(-10, 0, 0)

func _ready() -> void:
	for i in range(lights):
		var light = OmniLight3D.new()
		light.position = step * i
		light.light_energy = 5
		light.omni_range = 20
		add_child(light)
