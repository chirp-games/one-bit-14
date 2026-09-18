extends RigidBody3D


@export var launch_force: float = 4

var resetting = false
var watchdog = 0

func launch() -> void:
	apply_central_impulse(Vector3.LEFT * launch_force)

func reset() -> void:
	freeze = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ONE * 0.001, 0.5)
	tween.tween_property(self, "global_position",  start_position, 0)
	tween.tween_property(self, "global_rotation",  Vector3.ZERO, 0)
	tween.tween_property(self, "scale", Vector3.ONE, 0.5)
	tween.tween_property(self, "freeze", false, 0)
	tween.tween_property(self, "resetting", false, 0)
	tween.tween_property(self, "watchdog", 0, 0)
	tween.tween_callback(launch)

@onready var start_position = global_position

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	launch()

func _physics_process(delta: float) -> void:
	watchdog += delta
	if (global_position.distance_to(start_position) > 50 or watchdog > 8) and not resetting:
		resetting = true
		reset()
