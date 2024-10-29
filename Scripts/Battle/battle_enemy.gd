@tool
class_name BattleEnemy
extends BattleAvatar

@export var enemy_id: BattleGlobals.Enemy:
	set(enemy):
		enemy_id = enemy
		refresh_enemy_data()

@onready var enemy_sprite: Sprite2D = $EnemySprite
@onready var element_hitbox: ElementHitbox = $ElementHitbox
var sprite_region: Rect2 = Rect2(0, 0, 1, 1)

func _ready():
	refresh_enemy_data()
	element_hitbox.cursor.scale = Vector2.ONE * 0.5
	element_hitbox.hp_text.scale = Vector2.ONE * 0.5

func refresh_enemy_data():
	visible = enemy_id != BattleGlobals.Enemy.None
	av_name = BattleGlobals.get_enemy_property(enemy_id, BattleGlobals.EnemyProperty.Name)
	sprite_region = BattleGlobals.get_enemy_property(enemy_id, BattleGlobals.EnemyProperty.SpriteRegion)
	if enemy_sprite:
		enemy_sprite.texture.region = sprite_region
	if element_hitbox:
		element_hitbox.size = sprite_region.size
		element_hitbox.position = -(sprite_region.size / 2)
		element_hitbox.cursor_pos = BattleGlobals.get_enemy_property(enemy_id, BattleGlobals.EnemyProperty.CursorPos)
		element_hitbox.hp_text_pos = BattleGlobals.get_enemy_property(enemy_id, BattleGlobals.EnemyProperty.HpTextPos)
