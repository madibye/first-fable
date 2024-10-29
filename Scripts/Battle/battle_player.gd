@tool
class_name BattlePlayer
extends BattleAvatar

@export var player_class: BattleGlobals.PlayerClass:
	set(p_class):
		player_class = p_class
		refresh_sprite_frame()
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite

@export var sprite_frame: int = 0:
	set(frame):
		if frame in range(-1, 6):
			sprite_frame = frame
			refresh_sprite_frame()
@export var party_slot = 1

var sprite_offsets = {
	BattleGlobals.PlayerClass.Warrior: 0,
	BattleGlobals.PlayerClass.Rogue: 6,
	BattleGlobals.PlayerClass.BlackBelt: 12,
	BattleGlobals.PlayerClass.RedMage: 18,
	BattleGlobals.PlayerClass.BlackMage: 24,
	BattleGlobals.PlayerClass.WhiteMage: 30,
}

func _ready():
	player_class = PartyInfo.get_player_property(party_slot, PartyInfo.PartyData.PlayerClass)
	av_name = PartyInfo.get_player_property(party_slot, PartyInfo.PartyData.AvName)
	moves = []
	for move_id in PartyInfo.get_player_property(party_slot, PartyInfo.PartyData.Moves):
		var cls = BattleGlobals.get_move_property(move_id, BattleGlobals.MoveProperty.Class)
		if not cls is GDScript:
			continue
		var move = cls.new()
		move.move_id = move_id
		moves.append(move)

func refresh_sprite_frame():
	if not player_sprite or not sprite_frame in range(-1, 6):
		return
	if sprite_frame == -1:
		player_sprite.animation = "knocked_out"
		player_sprite.frame = player_class
	else:
		player_sprite.animation = "default"
		player_sprite.frame = sprite_frame + (sprite_offsets.get(player_class, 0))
