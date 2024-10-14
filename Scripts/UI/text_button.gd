@tool
class_name TextButton
extends Element

@export_multiline var text: String = "":
	set(t):
		text = t
		if not text_display: await ready
		text_display.text = t
@onready var text_display: TextDisplay = $TextDisplay
@onready var element_hitbox: ElementHitbox = $ElementHitbox
