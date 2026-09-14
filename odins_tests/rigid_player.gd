extends RigidBody3D

const WALK_FORCE = 15
const JUMP_IMPULSE = 5
const LOOK_VELOCITY_Y = 0.01

@onready var camera = %Camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_event := event as InputEventMouseMotion
		rotate_y(
			camera.rotation_degrees.y + mouse_event.relative.x * -LOOK_VELOCITY_Y
		)
		camera.rotate_x(
			mouse_event.relative.y * -LOOK_VELOCITY_Y
		)
		camera.rotation.x = clampf(camera.rotation.x, -PI/2, PI/2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		self.apply_impulse(Vector3(0,1.,0) * JUMP_IMPULSE)

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		self.apply_central_force(direction * WALK_FORCE)
	
	
