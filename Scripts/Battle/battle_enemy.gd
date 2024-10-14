@tool
class_name BattleEnemy
extends BattleAvatar

@export var enemy_type: Enemy
@onready var enemy_sprite: Sprite2D = $EnemySprite
var sprite_region: Rect2 = Rect2(0, 0, 1, 1)

# TODO: move this somewhere else lol
enum Enemy {Jester, BLJster, Wolf, Hector, Knight}
enum EnemyData {Name, SpriteRegion}
var enemy_data: Dictionary = {
	Enemy.Jester: {
		EnemyData.Name: "Jester",
		EnemyData.SpriteRegion: Rect2(9, 23, 31, 31),
	},
	Enemy.Knight: {
		EnemyData.Name: "Knight",
		EnemyData.SpriteRegion: Rect2(147, 13, 44, 46),
	},
	Enemy.BLJster: {
		EnemyData.Name: "BLJster",
		EnemyData.SpriteRegion: Rect2(43, 24, 31, 31),
	},
	Enemy.Wolf: {
		EnemyData.Name: "Wolf",
		EnemyData.SpriteRegion: Rect2(80, 28, 30, 29),
	},
	Enemy.Hector: {
		EnemyData.Name: "Hector",
		EnemyData.SpriteRegion: Rect2(116, 28, 30, 29),
	},
}

func _process(_delta):
	av_name = enemy_data.get(enemy_type, {}).get(EnemyData.Name, av_name)
	sprite_region = enemy_data.get(enemy_type, {}).get(EnemyData.SpriteRegion, sprite_region)
	enemy_sprite.texture.region = sprite_region
	# pass
