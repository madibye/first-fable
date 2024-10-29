@tool
class_name HPTracker
extends NinePatchRect

@export_node_path("BattleAvatar") var avatar_path: NodePath:
	set(path):
		avatar_path = path
		avatar = get_node_or_null(avatar_path)
@onready var avatar: BattleAvatar
@onready var prev_text: String = ""
@onready var text_display: TextDisplay = $TextDisplay

func _ready():
	avatar_path = avatar_path

func update_text():
	if not avatar or not text_display:
		return
	var current_text = "%s\nHP\n %sl%s" % [avatar.av_name, avatar.hp, avatar.max_hp]
	if current_text != prev_text:
		text_display.text = current_text
		prev_text = current_text

func _process(_delta):
	if get_parent() is BattleScene:
		visible = avatar != null
		if avatar is BattleEnemy:
			visible = avatar.enemy_id != BattleGlobals.Enemy.None
	update_text()
