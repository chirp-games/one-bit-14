class_name PathFollowPlatform

extends PathFollow3D

@export var speed = .05

enum MovementMode {
	Stopped,
	Forward,
	Back,
}

@export var movement_mode: MovementMode = MovementMode.Stopped

@export var normalise_speed := false

@onready var parent: Path3D = get_parent()

func _physics_process(delta: float) -> void:
	if movement_mode == MovementMode.Forward:
		progress_ratio = clamp(
			progress_ratio +
				((speed / parent.curve.get_baked_length()) if normalise_speed else speed) *
				delta,
			0,
			1
		)
	if movement_mode == MovementMode.Back:
		clamp(
			progress_ratio -
				((speed / parent.curve.get_baked_length()) if normalise_speed else speed) *
				delta,
			0,
			1
		)
	%Platform.global_position = global_position

func stop() -> void:
	movement_mode = MovementMode.Stopped

func forward() -> void:
	movement_mode = MovementMode.Forward

func back() -> void:
	movement_mode = MovementMode.Back
