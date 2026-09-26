extends Resource
class_name LevelInfo

## The next level after this one.
@export var next: LevelInfo
## The name of the level, may give a hint to what the puzzle is.
## Must be unique.
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
## If true, unlocks all normal levels when this level is complete
@export var unlocks_normal := false
## Challenge levels unlock after all non-challenge levels have been completed.
@export var challenge := false
## Gives the level a cool particle effect to promote it to players.
@export var special := false
