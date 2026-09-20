extends Node3D

const STEP = 0.5
const TURN_FACTOR := STEP / 10
@export var max_length := 30

var effectors: Array[Node]
var direction = Vector3.FORWARD
var endpoint = Vector3.ZERO

func propagate() -> void:
	# Disable the laser's logic when it is hidden to reduce lag and to
	# prevent the player from dying when they touch it
	if not visible:
		return

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
			if hit["collider"].has_signal("laser_hit"):
				hit["collider"].emit_signal("laser_hit")
			break

		endpoint += target
		curve.add_point(endpoint)

	if curve.point_count <= 1:
		return

	# Only update the visuals if we have a different shape curve
	if not are_curves_equal(%VisibleCurve.curve, curve):
		%VisibleCurve.curve = curve.duplicate()
		update_sprites()

var height = .025

func update_sprites():
	var length = curve.get_baked_length()

	var vertices = PackedVector3Array()

	var pos = 0
	while pos < length:
		var p1 = curve.sample_baked(pos)
		var p2 = curve.sample_baked(pos + 0.5)
		# bottom
		vertices.push_back(Vector3(p2.x + height, p2.y + height, p2.z))
		vertices.push_back(Vector3(p1.x + height, p1.y + height, p1.z))
		vertices.push_back(Vector3(p2.x + height, p2.y - height, p2.z))

		vertices.push_back(Vector3(p1.x + height, p1.y - height, p1.z))
		vertices.push_back(Vector3(p2.x + height, p2.y - height, p2.z))
		vertices.push_back(Vector3(p1.x + height, p1.y + height, p1.z))

		# Top
		vertices.push_back(Vector3(p2.x - height, p2.y + height, p2.z))
		vertices.push_back(Vector3(p1.x - height, p1.y + height, p1.z))
		vertices.push_back(Vector3(p2.x - height, p2.y - height, p2.z))

		vertices.push_back(Vector3(p1.x - height, p1.y - height, p1.z))
		vertices.push_back(Vector3(p2.x - height, p2.y - height, p2.z))
		vertices.push_back(Vector3(p1.x - height, p1.y + height, p1.z))

		# Left
		vertices.push_back(Vector3(p2.x - height, p2.y + height, p2.z))
		vertices.push_back(Vector3(p1.x - height, p1.y + height, p1.z))
		vertices.push_back(Vector3(p2.x + height, p2.y + height, p2.z))

		vertices.push_back(Vector3(p1.x + height, p1.y + height, p1.z))
		vertices.push_back(Vector3(p2.x + height, p2.y + height, p2.z))
		vertices.push_back(Vector3(p1.x - height, p1.y + height, p1.z))

		# Right
		vertices.push_back(Vector3(p2.x - height, p2.y - height, p2.z))
		vertices.push_back(Vector3(p1.x - height, p1.y - height, p1.z))
		vertices.push_back(Vector3(p2.x + height, p2.y - height, p2.z))

		vertices.push_back(Vector3(p1.x + height, p1.y - height, p1.z))
		vertices.push_back(Vector3(p2.x + height, p2.y - height, p2.z))
		vertices.push_back(Vector3(p1.x - height, p1.y - height, p1.z))




		pos += 0.5

	# Initialize the ArrayMesh.
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices

	# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	%Laser.mesh = arr_mesh

func are_curves_equal(a: Curve3D, b: Curve3D):
	if a.point_count == 0 or b.point_count == 0:
		return false
	if a.point_count != b.point_count:
		return false
	var a_points = a.get_baked_points()
	var b_points = b.get_baked_points()
	for i in a.point_count:
		if a_points[i] != b_points[i]:
			return false
	return true

@onready var curve: Curve3D = Curve3D.new()
@onready var collisionRay: RayCast3D = $Collider

func _ready() -> void:
	await get_tree().process_frame
	effectors = get_tree().get_nodes_in_group("curves_light")



func _physics_process(_delta: float) -> void:
	propagate()
