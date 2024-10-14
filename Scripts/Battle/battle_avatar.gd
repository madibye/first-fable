@tool
class_name BattleAvatar
extends Element

@export var av_name: String = "Avatar"
@export var hp: int = 20
@export var max_hp: int = 20
var battle_scene: BattleScene
@onready var moves = [MoveBase.new(), MoveBase.new(), MoveBase.new(), MoveBase.new()]

func _ready():
	moves[0].move_name = "Magical Shine"
	moves[1].move_name = "Fiery Blaze"
	moves[2].move_name = "Lightning Strike"
	moves[3].move_name = "Ice Storm"

# maybe this belongs elsewhere IDK
func show_hp_text(shp: int):
	if shp == 0 or not hitbox:
		return
	var hp_text: TextDisplay = hitbox.hp_text.duplicate()
	hitbox.add_child(hp_text)
	hp_text.reparent(battle_scene)
	hp_text.show()
	hp_text.text = "%s%s" % ['+' if shp > 0 else '', str(shp)]
	var tween: Tween = create_tween()
	tween.tween_property(hp_text, "position", hp_text.position - Vector2(0, 30), 1.0)
	tween.parallel().tween_property(hp_text, "modulate:a", 0, 0.5).set_delay(0.5)
	await tween.finished
	hp_text.queue_free()
