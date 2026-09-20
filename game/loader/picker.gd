@tool
extends Control


const item = preload("res://game/loader/pick_item.tscn")
const code = [
	KEY_UP, KEY_UP, KEY_DOWN, KEY_DOWN,
	KEY_LEFT, KEY_RIGHT, KEY_LEFT, KEY_RIGHT,
	KEY_A, KEY_B 
]

@export var bypass_unlocks = false

var progress = []
var status = 0

func quit() -> void:
	get_tree().quit()

func reset_unlocks() -> void:
	LevelManager.reset_unlocks()
	for button in %LevelList.get_children():
		button.check_locked()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	for level in LevelManager.levels:
		var button = item.instantiate()
		button.level = level
		button.bypass = bypass_unlocks
		%LevelList.add_child(button)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == code[status]:
				status += 1
				if status == len(code):
					LevelManager.unlock_all()
					for button in %LevelList.get_children():
						button.check_locked()
					status = 0
			else:
				status = 0
