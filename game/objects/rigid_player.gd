extends RigidBody3D

signal create_black_hole(position: Vector3)
signal delete_black_hole
## Black hole placement
signal set_blackholes_enabled(enabled: bool)
signal reset_level
signal lethal

const WALK_FORCE = 30
const AIR_WALK_FORCE = 10
const JUMP_IMPULSE = 5.5
const LOOK_VELOCITY_Y = 0.01
const CAYOTE_TIME = .1
const MAX_GROUND_VELOCTIY = 7

const MAX_CHARGES := 1
const RECHARGE_TIME := 0.3

var cayote_timer = 0
var on_floor: bool = false

var BLACK_HOLE_PLACEMENT_DIST_MAX = 5.0
var BLACK_HOLE_PLACEMENT_DIST_MIN = 1.0
var BLACK_HOLE_PLACEMENT_MOVEMENT_ON_SCROLL = .1
var black_hole_position = 0.0

var charges := 1 :
	set(value):
		charges = value
		%HoleCharges.text = str(charges)
		if charges == 0:
			%Gun.show_recharge_status(true)
			set_blackholes_enabled.emit(false)
		else:
			%Gun.show_recharge_status(false)
			set_blackholes_enabled.emit(true)
var recharging := false:
	set(val):
		recharging = val
	get():
		return recharging
var charge_tween: Tween

var held_object

@onready var camera = %Camera
@onready var blackhole_ray: RayCast3D = %CreateBlackHoleRay

func clamp_players_velocity(max_velocity):
	var v = Vector2(linear_velocity.x, linear_velocity.z)
	if v.length() > max_velocity:
		linear_velocity.x = max_velocity * cos(v.angle())
		linear_velocity.z = max_velocity * sin(v.angle())

func position_black_hole_preview():
	%BlackHolePreview.global_position = (
		blackhole_ray.global_position +
		blackhole_ray.global_position.direction_to(
			blackhole_ray.global_transform * Vector3.FORWARD
		) *
		(
			to_local(blackhole_ray.get_collision_point()) if
			blackhole_ray.is_colliding() else
			blackhole_ray.target_position
		).length()
	)

func recharge() -> void:
	if not recharging:
		return
	recharging = false
	charges += 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	%HoleRecharge.max_value = RECHARGE_TIME
	%HoleRecharge.step = RECHARGE_TIME / 100

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
		black_hole_position = clampf(
			black_hole_position + BLACK_HOLE_PLACEMENT_MOVEMENT_ON_SCROLL,
			0.,
			1.,
		)

	if event.is_action("scroll_down"):
		black_hole_position = clampf(
			black_hole_position - BLACK_HOLE_PLACEMENT_MOVEMENT_ON_SCROLL,
			0.,
			1.,
		)

	blackhole_ray.target_position.z = -1 * black_hole_position * (BLACK_HOLE_PLACEMENT_DIST_MAX - BLACK_HOLE_PLACEMENT_DIST_MIN) - BLACK_HOLE_PLACEMENT_DIST_MIN

	if event.is_action_pressed("click") and charges > 0:
		charges -= 1
		%HoleRecharge.value = 0
		create_black_hole.emit(%BlackHolePreview.global_position)
	if event.is_action_pressed("right_click"):
		delete_black_hole.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	cayote_timer += delta

	if on_floor:
		if charges < MAX_CHARGES and not recharging:
			recharging = true
			charge_tween = get_tree().create_tween()
			charge_tween.tween_property(%HoleRecharge, 'value', RECHARGE_TIME, RECHARGE_TIME)
			charge_tween.tween_callback(recharge)
		cayote_timer = 0
	else:
		recharging = false
		if charge_tween and charge_tween.is_running():
			charge_tween.stop()
			%HoleRecharge.value = 0

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
	
	if Input.is_action_just_pressed("reset"):
		reset_level.emit()

func _process(_delta: float) -> void:
	position_black_hole_preview()
	%Gun.set_charge(black_hole_position)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# https://forum.godotengine.org/t/how-to-check-if-rigid-body-is-on-floor/65679/3
	var i := 0
	on_floor = false
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		#  1.0 would be perfectly straight up
		#  0.0 is a wall
		# -1.0 is a ceiling
		if normal.dot(Vector3.UP) > 0.3: # this can be dialed in
			on_floor = true
		i += 1

func _on_lethal() -> void:
	print("died")
	reset_level.emit()
