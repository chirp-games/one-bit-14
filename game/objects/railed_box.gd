@tool

class_name RailedBox

extends Node3D

var path: Path3D

func _ready() -> void:
	path = get_parent()
	
	if path != null:
		%PathMesh3D.path_3d = path

	%PathMesh3D.global_rotation = Vector3(0, 0, 0)

	var dist = path.curve.get_point_position(0).distance_to(path.curve.get_point_position(1))
	%SliderJoint3D.set_param(SliderJoint3D.PARAM_LINEAR_LIMIT_UPPER, dist - 1)
