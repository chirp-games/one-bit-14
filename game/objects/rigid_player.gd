extends RigidBody3D

const WALK_FORCE = 30
const JUMP_IMPULSE = 5
const LOOK_VELOCITY_Y = 0.01
const CAYOTE_TIME = .1

const GROUND_FRICTION = 1.25

var cayote_timer = 0
var on_floor: bool = false

@onready var camera = %Camera

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	cayote_timer += delta

	if Input.is_action_just_pressed("jump") and cayote_timer < CAYOTE_TIME:
		apply_impulse(Vector3(0,1.,0) * JUMP_IMPULSE)
		print("HELLO")
		cayote_timer += 100

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (%Mesh.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if on_floor:
		cayote_timer = 0

	if direction:
		apply_central_force(direction * WALK_FORCE)

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
