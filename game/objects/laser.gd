extends Node3D


const STEP = 0.1
const TURN_FACTOR := 0.01

@export var max_length := 100

var length = 0
var direction = Vector3.FORWARD
var endpoint = Vector3.ZERO

func propagate() -> void:
	length = 0
	direction = Vector3.FORWARD
	endpoint = Vector3.ZERO
	curve.clear_points()
	var effectors = get_tree().get_nodes_in_group("curves_light")
	
	while max_length > length:
		for object in effectors:
			var dist = (global_position + endpoint).distance_to(object.global_position)
			direction = direction.slerp(
				(global_position + endpoint).direction_to(object.global_position),
				clamp(TURN_FACTOR / float(pow(dist, 1.5)), 0, 1)
			)
		
		var target = direction.normalized() * STEP
		collisionRay.position = endpoint
		collisionRay.target_position = endpoint + target
		collisionRay.force_raycast_update()
		if collisionRay.is_colliding():
			endpoint = to_local(collisionRay.get_collision_point())
			curve.add_point(endpoint)
			break
		
		endpoint += target
		curve.add_point(endpoint)
		length += STEP

@onready var curve: Curve3D = $Path3D.curve
@onready var collisionRay: RayCast3D = $Collider

func _ready() -> void:
	propagate()
