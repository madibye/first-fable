@tool
class_name BattlePlayer
extends BattleAvatar

const PlayerClass = OverworldPlayer.Class

@export var player_class: PlayerClass
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@export var sprite_frame: int = 0:
	set(frame):
		if frame in range(-1, 6):
			sprite_frame = frame 

var sprite_offsets = {
	PlayerClass.Warrior: 0,
	PlayerClass.Rogue: 6,
	PlayerClass.BlackBelt: 12,
	PlayerClass.RedMage: 18,
	PlayerClass.BlackMage: 24,
	PlayerClass.WhiteMage: 30,
}

func _process(_delta):
	set_sprite_frame(sprite_frame)

func set_sprite_frame(frame: int):
	if frame == -1:
		player_sprite.animation = "knocked_out"
		player_sprite.frame = player_class
	elif frame in range(0, 6):
		player_sprite.animation = "default"
		player_sprite.frame = frame + (sprite_offsets.get(player_class, 0))
