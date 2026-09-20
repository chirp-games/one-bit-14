@tool
extends MarginContainer


const game_scene = "res://game/render.tscn"

@export var slant_mult = 0.1
@export var hover_mult = 1.5
@export var press_mult = 1.4

var level: LevelInfo = preload("res://resources/levels/level_1.tres") : 
	set(value):
		level = value
		update_text()
		check_locked()
var hovering = false
var pressing = false
var loading = false
var enabled = false
var bypass = false
var start_size

func check_locked() -> void:
	if Engine.is_editor_hint():
		return
	var unlocks: Array = ConfigManager.get_value("unlocks")
	enabled = level.number in unlocks

func update_text() -> void:
	%Button.text = "%d - %s" % [level.number, level.name]

func load_level() -> void:
	# Has to be specified or all levels move
	loading = true
	# Autoload persists between scene change
	LevelManager.current_number = level.number
	ResourceLoader.load_threaded_request(game_scene)

func _ready() -> void:
	update_text()
	check_locked()
	
	await get_tree().process_frame
	start_size = size

func _process(_delta: float) -> void:
	if Rect2(
		Vector2.ZERO,
		Vector2(
			size.x + (start_size.x if start_size else size.x) * slant_mult,
			size.y - %Line.width
		)
	).has_point(get_local_mouse_position()) and (enabled or bypass):
		if not hovering:
			create_tween().tween_property(self, "size", Vector2(start_size.x * hover_mult, size.y), 0.1)
			hovering = true
	elif hovering and not pressing:
		create_tween().tween_property(self, "size", Vector2(start_size.x, size.y), 0.1)
		hovering = false

	var progress = []
	var status = ResourceLoader.load_threaded_get_status(game_scene, progress)
	if status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE or not loading:
		return
	elif status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		create_tween().tween_property(
			self,
			"size",
			Vector2(lerpf(start_size.x * hover_mult, get_tree().root.size.x * 2, progress[0]), size.y),
			0.1
		)
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		await get_tree().create_timer(0.1).timeout
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(game_scene))

func _gui_input(event: InputEvent) -> void:
	if not (enabled or bypass):
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			pressing = true
			create_tween().tween_property(self, "size", Vector2(start_size.x * press_mult, size.y), 0.1)
		else:
			pressing = false
			if Rect2(
				Vector2.ZERO,
				Vector2(
					size.x + (start_size.x if start_size else size.x) * slant_mult,
					size.y - %Line.width
				)
			).has_point(get_local_mouse_position()):
				load_level()

func _draw() -> void:
	var half = %Line.width / 2
	var points = PackedVector2Array([
		Vector2(half, half),
		Vector2(size.x + (start_size.x if start_size else size.x) * slant_mult - half, half),
		Vector2(size.x - half, size.y - half),
		Vector2(half, size.y - half)
	])

	%Line.points = points
