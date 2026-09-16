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
	
	while max_length > length:
		for object in effectors:
			var dist = endpoint.distance_to(to_local(object.global_position))
			direction = direction.slerp(
				endpoint.direction_to(to_local(object.global_position)),
				clamp(TURN_FACTOR / float(pow(dist, 1.5)), 0, 1)
			).normalized()
		
		var target = direction * STEP
		collisionRay.position = endpoint
		collisionRay.target_position = target
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
@onready var effectors = get_tree().get_nodes_in_group("curves_light")

func _ready() -> void:
	#get_tree().call_group("curves_light", "connect", "updated", propagate)
	pass

func _process(_delta: float) -> void:
	propagate()
