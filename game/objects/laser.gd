extends Node3D


const STEP = 0.2
const TURN_FACTOR := STEP / 10

@export var max_length := 30

var direction = Vector3.FORWARD
var endpoint = Vector3.ZERO

func propagate() -> void:
	direction = Vector3.FORWARD
	endpoint = Vector3.ZERO
	curve.clear_points()
	
	var effector_positions = []
	for object in effectors:
		effector_positions.push_back(to_local(object.global_position))
	
	var space_state := get_world_3d().direct_space_state

	for i in int(max_length / STEP):
		for pos in effector_positions:
			var dist = endpoint.distance_to(pos)
			
			if dist > 5:
				continue
			
			direction = direction.slerp(
				endpoint.direction_to(pos),
				clamp(TURN_FACTOR / float(pow(dist, 1.5)), 0, 1)
			).normalized()
		
		var target = direction * STEP
		var query := PhysicsRayQueryParameters3D.create(
			to_global(endpoint),
			to_global(endpoint + target),
			0b100 # Light colliders have bit 3 set
		)

		var hit := space_state.intersect_ray(query)
		
		if len(hit) > 0:
			curve.add_point(to_local(hit["position"]))
			break
		
		endpoint += target
		curve.add_point(endpoint)

@onready var curve: Curve3D = $Path3D.curve
@onready var collisionRay: RayCast3D = $Collider
@onready var effectors = get_tree().get_nodes_in_group("curves_light")

func _physics_process(_delta: float) -> void:
	propagate()
