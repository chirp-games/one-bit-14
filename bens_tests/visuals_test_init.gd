@tool

extends Node3D

func _on_ready():
	$MeshInstance3D3.material_override.set_instance_shader_parameter("brightness",0.1);
