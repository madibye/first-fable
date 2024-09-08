@tool
class_name Textbox
extends NinePatchRect

signal move_text

@onready var text_display: TextDisplay = $VisMask/TextDisplay
@export_multiline var text: String = ""

@export var move_text_along_in_editor: bool = false:
	set(_s):
		move_text_along()
var current_lines: Array[int] = []

func _ready():
	text_display.max_display_lines = 3
	text_display.char_queue = text.rsplit()
	move_text.connect(move_text_along)

func _input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		move_text_along()
	
func get_split_lines() -> PackedStringArray:
	return text.split('\n')

func move_text_along() -> void:
	var tween = create_tween()
	var tileset_height = text_display.tile_set.tile_size.y
	tween.tween_property(text_display, "position:y", text_display.position.y - tileset_height, 0.3)
	await tween.step_finished
	print("hi")
	text_display.move_cells_up()
	text_display.position.y += tileset_height
