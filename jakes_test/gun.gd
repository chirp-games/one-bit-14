extends Node3D

func set_dist(f: float):
	$Cube_003.set_instance_shader_parameter("black_hole_distance", f)

func set_charge(f: float):
	$Gun.set_instance_shader_parameter("charge", f)
