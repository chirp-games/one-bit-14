extends RigidBody3D

signal create_black_hole(position: Vector3)
signal delete_black_hole
## Black hole placement
signal set_blackholes_enabled(enabled: bool)
signal reset_level
signal lethal

const WALK_FORCE = 120
const AIR_WALK_FORCE = 15
const JUMP_IMPULSE = 6.5
const LOOK_VELOCITY_Y = 0.01
const CAYOTE_TIME = .1
const MAX_GROUND_VELOCTIY = 8
const AIR_RESISTANCE = 1.

const MAX_CHARGES := 1

# We don't use the hole recharge animation for the time it takes to recharge
@onready var RECHARGE_TIME: float  = .3

var cayote_timer = 0
var on_floor: bool = false
var black_hole_placed_position = Vector3(0, 0, 0)

var BLACK_HOLE_PLACEMENT_DIST_MAX = 5.0
var BLACK_HOLE_PLACEMENT_DIST_MIN = 1.0
var BLACK_HOLE_PLACEMENT_MOVEMENT_ON_SCROLL = .1
var black_hole_position = 0.75

var floor: Object

var charges := 1 :
	set(value):
		charges = value
		%HoleCharges.text = str(charges)
		if charges == 0:
			set_blackholes_enabled.emit(false)
		else:
			set_blackholes_enabled.emit(true)
var recharging := false:
	set(val):
		recharging = val
	get():
		return recharging
var charge_tween: Tween

var held_object

@onready var camera = %Camera
@onready var blackhole_ray: SpringArm3D = %CreateBlackHoleRay

func clamp_players_velocity(max_velocity):
	var v = Vector2(linear_velocity.x, linear_velocity.z)
	if v.length() > max_velocity:
		linear_velocity.x = max_velocity * cos(v.angle())
		linear_velocity.z = max_velocity * sin(v.angle())

func position_black_hole_preview():
	var direction = blackhole_ray.position.direction_to(
			blackhole_ray.transform * Vector3.FORWARD
	)
	
	var spring_arm_len = blackhole_ray.get_hit_length()
	var position_along_ray = black_hole_position * (BLACK_HOLE_PLACEMENT_DIST_MAX - BLACK_HOLE_PLACEMENT_DIST_MIN) + BLACK_HOLE_PLACEMENT_DIST_MIN

	if position_along_ray > spring_arm_len:
		position_along_ray = spring_arm_len

	%BlackHolePreview.position = -position_along_ray * direction

func recharge() -> void:
	if not recharging:
		return
	recharging = false
	charges += 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%GunMovementAnimationPlayer.play("RESET")
	
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

	if event.is_action_pressed("click") and charges > 0:
		charges -= 1
		%HoleRecharge.value = 0
		%GunMovementAnimationPlayer.play("fire", .05)
		black_hole_placed_position = %BlackHolePreview.global_position
		create_black_hole.emit(%BlackHolePreview.global_position)
	if event.is_action_pressed("right_click"):
		black_hole_placed_position = Vector3.ZERO
		delete_black_hole.emit()
		%GunMovementAnimationPlayer.play("release_black_hole")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print(self.transform)
	if not on_floor:
		cayote_timer += delta

	if on_floor:
		# Do not start the recharging until recoil is over
		var is_reloading = %GunMovementAnimationPlayer.current_animation == "fire" and %GunMovementAnimationPlayer.is_playing()
		if charges < MAX_CHARGES and not recharging and not is_reloading:
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
		var friction = 1.
		if floor:
			var floor_material = floor.get("physics_material")
			if floor_material:
				friction = max(0.01, floor_material.friction)
			else:
				apply_central_force(-self.linear_velocity.normalized() * pow((1 + friction), 2))
		if direction:
			var limiter: Vector3 = Vector3(0., 0., 0.)
			var dot = direction.dot(self.linear_velocity)
			if dot > 0:
				limiter = -self.linear_velocity.normalized() * min(dot / MAX_GROUND_VELOCTIY, 1)
			apply_central_force((direction + limiter) * WALK_FORCE * friction)
	else:
		apply_central_force(direction * AIR_WALK_FORCE)
	# yk what you are always in the air
	apply_central_force(-self.linear_velocity.normalized() * self.linear_velocity.length() * AIR_RESISTANCE)

	if on_floor and direction:
		if %GunBobAnimationPlayer.current_animation != "bob":
			%GunBobAnimationPlayer.play("bob")
	else:
		if %GunBobAnimationPlayer.current_animation != "RESET":
			%GunBobAnimationPlayer.play("RESET")

	if not %GunMovementAnimationPlayer.is_playing() or %GunMovementAnimationPlayer.current_animation == "cover" or %GunMovementAnimationPlayer.current_animation == "RESET":
		if cayote_timer > 0.1 and Vector2(linear_velocity.x, linear_velocity.z).length() > 5:
			%GunMovementAnimationPlayer.play("cover", .2)
		else:
			%GunMovementAnimationPlayer.play("RESET", .3)

	if Input.is_action_just_pressed("jump") and cayote_timer < CAYOTE_TIME:
		apply_impulse(Vector3(0,1.,0) * JUMP_IMPULSE)
		cayote_timer += 100
	
	if Input.is_action_just_pressed("reset"):
		reset_level.emit()

	# Rotate gun slightly torwards black hole
	if black_hole_placed_position != Vector3(0, 0, 0):
		var old_rotation = %RotateGunToBlackHole.rotation
		%RotateGunToBlackHole.look_at(black_hole_placed_position)
		%RotateGunToBlackHole.rotation.x = clampf(%RotateGunToBlackHole.rotation.x, -PI / 12 , PI / 12)
		%RotateGunToBlackHole.rotation.y = clampf(%RotateGunToBlackHole.rotation.y, -PI / 12, PI / 12)
		%RotateGunToBlackHole.rotation.z = clampf(%RotateGunToBlackHole.rotation.z, -PI / 12, PI / 12)
		%RotateGunToBlackHole.rotation = lerp(old_rotation, %RotateGunToBlackHole.rotation, 5 * delta)
	else:
		%RotateGunToBlackHole.rotation = lerp(%RotateGunToBlackHole.rotation, Vector3.ZERO, 5 * delta)

func _process(_delta: float) -> void:
	position_black_hole_preview()
	%Gun.set_charge(%HoleRecharge.value / RECHARGE_TIME)
	%Gun.set_dist(black_hole_position)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	# https://forum.godotengine.org/t/how-to-check-if-rigid-body-is-on-floor/65679/3
	var i := 0
	on_floor = false
	floor = null
	while i < state.get_contact_count():
		var normal := state.get_contact_local_normal(i)
		#  1.0 would be perfectly straight up
		#  0.0 is a wall
		# -1.0 is a ceiling
		if normal.dot(Vector3.UP) > 0.3: # this can be dialed in
			floor = state.get_contact_collider_object(i)
			on_floor = true
		i += 1

func _on_lethal() -> void:
	print("died")
	reset_level.emit()
