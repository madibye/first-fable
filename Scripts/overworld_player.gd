@tool
class_name OverworldPlayer
extends Actor

@onready var sprite_top_half: AnimatedSprite2D = $SpriteTopHalf
@onready var sprite_btm_half: AnimatedSprite2D = $SpriteBtmHalf
@onready var camera_mover: RemoteTransform2D = $CameraMover
@onready var actions_to_methods: Dictionary = {
	"move_left": move_tile.bind(Vector2.LEFT),
	"move_right": move_tile.bind(Vector2.RIGHT),
	"move_up": move_tile.bind(Vector2.UP),
	"move_down": move_tile.bind(Vector2.DOWN),
}
var class_offsets: Dictionary = {
	BattleGlobals.PlayerClass.BlackMage: 0,
	BattleGlobals.PlayerClass.WhiteMage: 8,
	BattleGlobals.PlayerClass.RedMage: 16,
	BattleGlobals.PlayerClass.Warrior: 24,
}
@export var player_class: BattleGlobals.PlayerClass = BattleGlobals.PlayerClass.BlackMage
var frame_offset: int
var level: OverworldLevel

func _ready():
	if not get_parent() is OverworldLevel:
		return
	set_level(get_parent())
	
func set_level(lv: OverworldLevel):
	level = lv
	set_camera_path()
	
func set_camera_path():
	for child in level.get_children().filter(func(a): return a is Camera2D):
		camera_mover.remote_path = child.get_path()
		
func _process(_delta):
	if player_class in class_offsets:
		frame_offset = class_offsets.get(player_class)
	if Engine.is_editor_hint():
		sprite_top_half.frame = 4 + frame_offset
		sprite_btm_half.frame = 0 + frame_offset
	if not controls_locked:
		match direction:
			Vector2.UP: set_sprite_frames(5, 1)
			Vector2.DOWN: set_sprite_frames(4, 0)
			Vector2.LEFT: 
				set_sprite_frames(6, 2)
				sprite_flip_h(false)
			Vector2.RIGHT:
				set_sprite_frames(6, 2)
				sprite_flip_h()
	if not Engine.is_editor_hint() and not controls_locked:
		if Input.is_action_just_pressed("interact"):
			do_interaction()
		for action in actions_to_methods:
			if Input.is_action_pressed(action):
				actions_to_methods[action].call()
				break
	

func set_camera_mover_path(cam: Camera2D):
	camera_mover.remote_path = cam.get_path()
	
func get_facing_tile():
	return Vector2i(Vector2(overworld_level.local_to_map(position)) + direction)
	
func do_interaction():
	var actor = overworld_level.actor_positions.find_key(get_facing_tile())
	if actor is Actor:
		actor.interact(self)

func move_tile(dir: Vector2):
	var move = true
	direction = dir
	if overworld_level.actor_positions.find_key(get_facing_tile()):
		move = false
	var tile_data = overworld_level.get_cell_tile_data(get_facing_tile())
	if move and tile_data is TileData:
		if not tile_data.get_custom_data("WalkCollision"):
			move = false
	controls_locked = true
	if move:
		create_tween().tween_property(self, "position", overworld_level.map_to_local(get_facing_tile()), move_time)
	do_walk_anim()
	get_tree().create_timer(move_time).timeout.connect(func(): controls_locked = false)

func do_walk_anim():
	match direction:
		Vector2.UP: do_vertical_walk_anim(5, 1)
		Vector2.DOWN: do_vertical_walk_anim(4, 0)
		Vector2.LEFT: do_horizontal_walk_anim()
		Vector2.RIGHT: do_horizontal_walk_anim(true)
	
func set_sprite_frames(top_half_frame: int, btm_half_frame: int):
	sprite_top_half.set_frame(top_half_frame + frame_offset)
	sprite_btm_half.set_frame(btm_half_frame + frame_offset)
	
func sprite_flip_h(flip: bool = true):
	sprite_top_half.flip_h = flip
	sprite_btm_half.flip_h = flip

func do_vertical_walk_anim(top_half_frame: int, btm_half_frame: int):
	set_sprite_frames(top_half_frame, btm_half_frame)
	await get_tree().create_timer(move_time*0.45).timeout
	sprite_btm_half.flip_h = not sprite_btm_half.flip_h
	await get_tree().create_timer(move_time*0.45).timeout
	sprite_btm_half.flip_h = not sprite_btm_half.flip_h
	
func do_horizontal_walk_anim(flip: bool = false):
	sprite_flip_h(flip)
	set_sprite_frames(6, 2)
	await get_tree().create_timer(move_time*0.45).timeout
	set_sprite_frames(7, 3)
	await get_tree().create_timer(move_time*0.45).timeout
	set_sprite_frames(6, 2)
