@tool
class_name TextDisplay
extends TileMapLayer

@export_multiline var text = ""
var display_chars: int = -1
var current_display_chars: int = -1
@export var max_display_chars: int = -1
@export var max_display_lines: int = -1
@export var instant_queue: bool = false
var hidden_lines: PackedInt32Array
var char_queue: PackedStringArray
var tile_queue = null
var total_display_chars: int = 0
var current_position: Vector2i = Vector2i(0, 0)
var prev_frame_data: Dictionary = {}

var text_to_tiles: Dictionary = {
	'0': Vector2i(0, 8), '1': Vector2i(1, 8), '2': Vector2i(2, 8), '3': Vector2i(3, 8), '4': Vector2i(4, 8), '5': Vector2i(5, 8),
	'6': Vector2i(6, 8), '7': Vector2i(7, 8), '8': Vector2i(8, 8), '9': Vector2i(9, 8), 'A': Vector2i(10, 8), 'B': Vector2i(11, 8),
	'C': Vector2i(12, 8), 'D': Vector2i(13, 8), 'E': Vector2i(14, 8), 'F': Vector2i(15, 8), 'G': Vector2i(0, 9), 'H': Vector2i(1, 9),
	'I': Vector2i(2, 9), 'J': Vector2i(3, 9), 'K': Vector2i(4, 9), 'L': Vector2i(5, 9), 'M': Vector2i(6, 9), 'N': Vector2i(7, 9), 
	'O': Vector2i(8, 9), 'P': Vector2i(9, 9), 'Q': Vector2i(10, 9), 'R': Vector2i(11, 9), 'S': Vector2i(12, 9), 'T': Vector2i(13, 9),
	'U': Vector2i(14, 9), 'V': Vector2i(15, 9), 'W': Vector2i(0, 10), 'X': Vector2i(1, 10), 'Y': Vector2i(2, 10), 'Z': Vector2i(3, 10),
	'a': Vector2i(4, 10), 'b': Vector2i(5, 10), 'c': Vector2i(6, 10), 'd': Vector2i(7, 10), 'e': Vector2i(8, 10), 'f': Vector2i(9, 10),
	'g': Vector2i(10, 10), 'h': Vector2i(11, 10), 'i': Vector2i(12, 10), 'j': Vector2i(13, 10), 'k': Vector2i(14, 10), 'l': Vector2i(15, 10),
	'm': Vector2i(0, 11), 'n': Vector2i(1, 11), 'o': Vector2i(2, 11), 'p': Vector2i(3, 11), 'q': Vector2i(4, 11), 'r': Vector2i(5, 11),
	's': Vector2i(6, 11), 't': Vector2i(7, 11), 'u': Vector2i(8, 11), 'v': Vector2i(9, 11), 'w': Vector2i(10, 11), 'x': Vector2i(11, 11),
	'y': Vector2i(12, 11), 'z': Vector2i(13, 11), "'": Vector2i(14, 11), ',': Vector2i(15, 11), '.': Vector2i(0, 12), '-': Vector2i(2, 12),
	'…': Vector2i(3, 12), '!': Vector2i(4, 12), '?': Vector2i(5, 12), '%': Vector2i(0, 14),
}

var text_to_tile_lists: Dictionary = {
	"STATUS": [Vector2i(10, 12), Vector2i(11, 12), Vector2i(12, 12), Vector2i(13, 12), Vector2i(14, 12)],
	"WEAPON": [Vector2i(15, 12), Vector2i(0, 13), Vector2i(1, 13), Vector2i(2, 13), Vector2i(3, 13)],
	"L_SWORD": [Vector2i(4, 13)], "HAMMER": [Vector2i(5, 13)], "R_SWORD": [Vector2i(6, 13)],
	"AXE": [Vector2i(7, 13)], "WAND": [Vector2i(8, 13)], "NUNCHUKS": [Vector2i(9, 13)], 
	"CHESTPLATE": [Vector2i(10, 13)], "SHIELD": [Vector2i(11, 13)], "HELMET": [Vector2i(12, 13)], 
	"GLOVES": [Vector2i(13, 13)], "RING": [Vector2i(14, 13)], "SHIRT": [Vector2i(14, 13)],
	"POTION": [Vector2i(1, 14)], "s|": [Vector2i(10, 14)], "L": [Vector2(6, 12)], "E": [Vector2(7, 12)],
	"eep": [Vector2(8, 12), Vector2(9, 12)],
	"PoisonStone": [Vector2i(2, 14), Vector2i(3, 14), Vector2i(4, 14), Vector2i(5, 14), Vector2i(6, 14),
		Vector2i(7, 14), Vector2i(8, 14), Vector2i(9, 14)],
	"MAGIC": [Vector2i(11, 14), Vector2i(12, 14), Vector2i(13, 14), Vector2i(14, 14)],
	"FIGHTDRINK": [Vector2i(15, 14), Vector2i(0, 15), Vector2i(1, 15), Vector2i(2, 15), Vector2i(3, 15),
		Vector2i(4, 15), Vector2i(5, 15), Vector2i(6, 15)],
}

func _ready():
	clear_cells()

func _process(_delta):
	clear_oob_cells()
	if Engine.is_editor_hint():
		var frame_data = {"text": text, "max_display_chars": max_display_chars, "max_display_lines": max_display_lines}
		if frame_data != prev_frame_data:
			update_text()
		prev_frame_data = frame_data
	if max_display_lines >= 0 and current_position.y >= max_display_lines:
		return
	if instant_queue:
		for _c in char_queue:
			process_char_queue()
	else:
		process_char_queue()
		
func update_text() -> void:
	clear_cells()
	current_position = Vector2i(0, 0)
	current_display_chars = 0
	char_queue = text.rsplit()
	
func clear_cells():
	for cell in get_cell_range():
		set_cell(cell, 0)
			
func get_cell_range(max_x: int = 28, max_y: int = 3) -> Array[Vector2i]:
	var cell_range: Array[Vector2i] = []
	for x in range(0, max_x):
		for y in range(0, max_y):
			cell_range.append(Vector2i(x, y))
	return cell_range
		
func process_char_queue():
	if (max_display_chars >= 0 and current_display_chars >= max_display_chars) or (len(char_queue) == 0): 
		return
	var c = char_queue[0]
	char_queue = char_queue.slice(1) # bc apparently you cant pop from PackedStringArray...
	match c:
		'[':
			for key in text_to_tile_lists:
				if ''.join(char_queue).begins_with(key + "]"):
					tile_queue = text_to_tile_lists[key].duplicate()
		']':
			tile_queue = null
		'\n':
			current_position = Vector2i(0, current_position.y + 1)
		_:
			var tile: Vector2i
			if tile_queue != null:
				if len(tile_queue) == 0: return
				tile = tile_queue.pop_front()
				set_cell(current_position, 0, tile)
			else:
				tile = text_to_tiles.get(c, -Vector2i.ONE)
				if tile == -Vector2i.ONE and c != " ": return
				set_cell(current_position, 0, text_to_tiles.get(c, Vector2(-1, -1)))
			current_position.x += 1
			current_display_chars += 1
		
func set_text(txt: String = "") -> void:
	text = txt

func get_split_lines() -> PackedStringArray:
	return text.split('\n')

func move_cells_up():
	for cell in get_cell_range():
		print(cell)
		var atlas_coords = get_cell_atlas_coords(cell)
		set_cell(cell)
		set_cell(Vector2i(cell.x, cell.y - 1), 0, atlas_coords)
	current_position.y -= 1
		
func clear_oob_cells():
	for cell in get_used_cells():
		if cell.y < 0 or cell.y >= max_display_lines: 
			set_cell(cell)
		current_display_chars -= 1