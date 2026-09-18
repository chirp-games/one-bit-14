@tool

class_name RailedBox

extends Node3D

# Percent offset to start box at
@export var start_offset: float

var path: Path3D

func _ready() -> void:
	path = get_parent()

	if path != null:
		%Rail.path_3d = path

	%Rail.global_rotation = Vector3(0, 0, 0)

	var dist = path.curve.get_point_position(0).distance_to(path.curve.get_point_position(1))
	%SliderJoint3D.set_param(SliderJoint3D.PARAM_LINEAR_LIMIT_LOWER, .6)
	%SliderJoint3D.set_param(SliderJoint3D.PARAM_LINEAR_LIMIT_UPPER, dist -.6)

	%RailedBox.global_position = path.global_position + start_offset * path.curve.get_point_position(1)

func _process(_delta: float) -> void:
	%FirstEnd.global_position = path.global_position + path.curve.get_point_position(0) - Vector3(0, 0, 0.05)
	%SecondEnd.global_position = path.global_position + path.curve.get_point_position(1) - Vector3(0, 0, 0.05)
