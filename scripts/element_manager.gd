class_name ElementManager
extends Node2D

# This class should be loaded as a child of a scene that has elements.
# Implements various methods to help manage elements.

signal element_selected(element: Element)

@onready var cursor: Sprite2D
var selected_element: Element
var targetable_elements: Array = []

func _ready():
	cursor = preload("res://Scenes/cursor.tscn").instantiate()
	add_child(cursor)
	
func _input(event):
	if (not event is InputEventMouseButton and not event.is_action_pressed("interact")) or not selected_element:
		return
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT or event.pressed == false:
			return
	selected_element.select()
	element_selected.emit(selected_element)

func target_element(element):
	if not element.visible:
		return
	if selected_element:
		untarget_element(selected_element)
	selected_element = element
	cursor.show()
	cursor.global_position = element.get_hitbox().cursor.global_position

func untarget_element(element):
	if selected_element != element:
		return
	cursor.hide()
	selected_element = null
	
func add_targetable_elements(elements):
	for element in elements:
		if not element is Element:
			continue
		targetable_elements.append(element)
		element.make_targetable(target_element, untarget_element)
		
func disable_targetable_elements(elements = targetable_elements):
	elements = elements.filter(func(e): return e in targetable_elements)
	if selected_element in elements:
		untarget_element(selected_element)
	for element in elements:
		element.make_untargetable(target_element, untarget_element)
		targetable_elements.erase(element)
		
func set_targetable_elements(elements):
	disable_targetable_elements()
	add_targetable_elements(elements)
