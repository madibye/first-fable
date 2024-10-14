class_name Element
extends Control

signal selected
@onready var hitbox: ElementHitbox

func _ready() -> void:
	hitbox = get_hitbox()
	if not hitbox:
		return
	hitbox.element = self

func get_hitbox() -> ElementHitbox:
	for child in get_children().filter(func(c): return c is ElementHitbox):
		hitbox = child
	return hitbox
	
func make_targetable(target_cb, untarget_cb) -> void:
	get_hitbox().mouse_entered.connect(target_cb.bind(self))
	get_hitbox().mouse_exited.connect(untarget_cb.bind(self))
	
func make_untargetable(target_cb, untarget_cb) -> void:
	get_hitbox().mouse_entered.disconnect(target_cb)
	get_hitbox().mouse_exited.disconnect(untarget_cb)
	
func select():
	selected.emit()
