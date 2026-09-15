extends RigidBody3D

signal create_black_hole(position: Vector3)

const WALK_FORCE = 30
const AIR_WALK_FORCE = 10
const JUMP_IMPULSE = 5
const LOOK_VELOCITY_Y = 0.01
const CAYOTE_TIME = .1
const MAX_GROUND_VELOCTIY = 7

const MIN_KICK_POWER = .5
const MAX_KICK_POWER = 2
const KICK_ANGLE_FROM_GROUND = PI / 8

var cayote_timer = 0
var on_floor: bool = false

var current_kick_power = 0:
	set(val):
		current_kick_power = val
		%Crosshair.set_kick_power(val)
var targeting_kick_obj = null
var targeting_kick_obj_collision_point = Vector3(0, 0, 0)

@onready var dither_viewport: SubViewport = %DitherViewport
@onready var outline_viewport: SubViewport = %OutlineViewport

@onready var camera = %Cameras

func clamp_players_velocity(max_velocity):
	var v = Vector2(linear_velocity.x, linear_velocity.z)
	if v.length() > max_velocity:
		linear_velocity.x = max_velocity * cos(v.angle())
		linear_velocity.z = max_velocity * sin(v.angle())

func try_set_targeting_kick_object():
	var obj: PhysicsBody3D = %KickRangeRayCast.get_collider()
	if obj == null:
		return null

	if obj.is_in_group("kickable"):
		targeting_kick_obj_collision_point = %KickRangeRayCast.get_collision_point()
		if obj is RigidBody3D:
			targeting_kick_obj = obj

	return null

func load_kick(delta):
	if targeting_kick_obj:
		current_kick_power += 3 * delta

func release_kick():
	var obj = targeting_kick_obj
	if obj:
		var impulse = current_kick_power * (MAX_KICK_POWER - MIN_KICK_POWER) + MIN_KICK_POWER
		# Kick the object in the direction the player is looking
		var direction = %KickRangeRayCast.global_position.direction_to(%KickRangeRayCast.global_transform * Vector3.FORWARD)
		# The camera rotation works slightly better for y I think
		direction.y = camera.rotation.x + PI / 4
		var rotated_impulse = impulse * direction
		obj.apply_impulse(rotated_impulse)

func position_black_hole_preview():
	%BlackHolePreview.global_position = %CreateBlackHoleRay.global_position + %CreateBlackHoleRay.global_position.direction_to(%CreateBlackHoleRay.global_transform * Vector3.FORWARD) * -%CreateBlackHoleRay.target_position.z

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		%Mesh.rotate_y(
			camera.rotation_degrees.y + mouse_event.relative.x * -LOOK_VELOCITY_Y
		)
		camera.rotate_x(
			mouse_event.relative.y * -LOOK_VELOCITY_Y
		)
		camera.rotation.x = clampf(camera.rotation.x, -PI/2, PI/2)

	if event.is_action("scroll_up"):
		%CreateBlackHoleRay.target_position.z -= .1
	if event.is_action("scroll_down"):
		%CreateBlackHoleRay.target_position.z += .1
		
	if event.is_action_pressed("click"):
		create_black_hole.emit(%BlackHolePreview.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	cayote_timer += delta

	if on_floor:
		cayote_timer = 0

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (%Mesh.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if on_floor:
		if direction:
			clamp_players_velocity(MAX_GROUND_VELOCTIY)
			apply_central_force(direction * WALK_FORCE)
		else:
			# Slow down the player when they are not pressing any keys on the ground
			clamp_players_velocity(MAX_GROUND_VELOCTIY * (1 - delta) / 5)
	else:
		if linear_velocity.length() < 7:
			apply_central_force(direction * AIR_WALK_FORCE)

	if Input.is_action_just_pressed("jump") and cayote_timer < CAYOTE_TIME:
		apply_impulse(Vector3(0,1.,0) * JUMP_IMPULSE)
		cayote_timer += 100

# Hack to move the camera to the right position
func _process(delta: float) -> void:
	%CameraDither.global_position = %Cameras.global_position
	%CameraDither.global_rotation = %Cameras.global_rotation
	%CameraOutline.global_position = %Cameras.global_position
	%CameraOutline.global_rotation = %Cameras.global_rotation
	
	if targeting_kick_obj != null:
		%Crosshair.show_kick_indicator()
	else:
		%Crosshair.hide_kick_indicator()

	if Input.is_action_just_pressed("kick"):
		try_set_targeting_kick_object()

	if Input.is_action_pressed("kick"):
		load_kick(delta)
	elif Input.is_action_just_released("kick"):
		if current_kick_power != 0:
			release_kick()
			current_kick_power = 0
			targeting_kick_obj = null

	position_black_hole_preview()

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# https://forum.godotengine.org/t/how-to-check-if-rigid-body-is-on-floor/65679/3
	var i := 0
	on_floor = false
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		#  1.0 would be perfectly straight up
		#  0.0 is a wall
		# -1.0 is a ceiling
		if normal.dot(Vector3.UP) > 0.8: # this can be dialed in
			on_floor = true
		i += 1
