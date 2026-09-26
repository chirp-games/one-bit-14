extends Resource
class_name LevelInfo

## The order in which the level appears
@export var number := "1"
## The name of the level, may give a hint to what the puzzle is
@export var name := ""
## The level scene - do not include the player object.
@export var scene: PackedScene

## Configure player starting state
@export_category("Player")
## The player's starting position, relative to the level scene origin
@export var start_position: Vector3
## The player's starting rotation
@export var start_rotation: Vector3
## Resets the player when below this threshold
@export var floor: int = -10

@export_category("Unlocks")
## Lock state when the game first runs or "Reset Progress" is pressed.
@export var starts_unlocked := false
## Array of levels unlocked when this level is completed.
@export var unlocks: Array[int] = []
## Challenge levels unlock after all non-challenge levels have been completed.
@export var challenge := false
## Gives the level a cool particle effect to promote it to players.
@export var special := false
