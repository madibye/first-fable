@tool
class_name ElementHitbox
extends Container

@export var cursor_pos: Vector2 = Vector2(-10, 7):
	set(p):
		cursor_pos = p
		refresh_element_data()
@export var hp_text_pos: Vector2 = Vector2(11, -2):
	set(p):
		hp_text_pos = p
		refresh_element_data()
@onready var cursor: Sprite2D = $Cursor
@onready var hp_text: TextDisplay = $HpText
@onready var element: Element

func _ready():
	cursor_pos = cursor_pos
	hp_text_pos = hp_text_pos
	
func refresh_element_data():
	if cursor:
		cursor.position = cursor_pos
	if hp_text:
		hp_text.position = hp_text_pos
