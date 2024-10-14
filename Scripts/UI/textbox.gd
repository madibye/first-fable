@tool
class_name Textbox
extends NinePatchRect

signal textbox_done

@onready var text_display: TextDisplay = $VisMask/TextDisplay
@onready var color_rect: ColorRect = $ColorRect
@onready var vis_mask: ColorRect = $VisMask
var tween_running: bool = false
@export_multiline var text: String = "":
	set(t):
		text = t
		if not text_display: await ready
		text_display.text = t
@export var lines_to_move: int = 1
@export var char_spacing: int = 8:
	set(i):
		char_spacing = i
		if not text_display: await ready
		text_display.char_spacing = i
@export var line_spacing: int = 10:
	set(i):
		line_spacing = i
		if not text_display: await ready
		text_display.line_spacing = i

@export var move_text_in_editor: bool = false:
	set(_s): move_text_along()
var current_lines: Array[int] = []

func _ready():
	text_display.char_queue = text.rsplit()
	
func _process(_delta):
	color_rect.size = size - Vector2(8, 8)
	vis_mask.size = color_rect.size
		
func _input(event):
	if not event is InputEventMouseButton:
		if event.is_action_pressed("interact"):
			move_text_along()
	elif event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		move_text_along()
	
func get_split_lines() -> PackedStringArray:
	return text.split('\n')

func move_text_along() -> void:
	if tween_running or text_display.char_queue_running:
		return
	if text_display.display_chars >= len(text):
		textbox_done.emit()
		return
	var tween = create_tween()
	var tileset_offset = text_display.tile_set.tile_size.y * lines_to_move
	var move_time = {
		1: 0.3,
		2: 0.45,
	}.get(lines_to_move, 0.3 * lines_to_move)
	tween.tween_property(text_display, "position:y", text_display.position.y - tileset_offset, move_time)
	tween_running = true
	await tween.step_finished
	tween_running = false
	for _i in lines_to_move:
		text_display.move_cells_up()
	text_display.position.y += tileset_offset
