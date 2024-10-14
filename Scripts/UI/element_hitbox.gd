@tool
class_name ElementHitbox
extends Container

@export var cursor_pos: Vector2 = Vector2(-10, 7)
@export var hp_text_pos: Vector2 = Vector2(11, -2)
@onready var cursor: Sprite2D = $Cursor
@onready var hp_text: TextDisplay = $HpText
@onready var element: Element

func _process(_delta):
	cursor.position = cursor_pos
	hp_text.position = hp_text_pos
