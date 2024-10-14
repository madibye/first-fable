class_name WellActor
extends Actor

func interact(player: OverworldPlayer):
	player.controls_locked = true
	var textbox = preload("res://Scenes/textbox.tscn").instantiate() as Textbox
	textbox.text = "This is a well.\nYou might think that there is something to it__\nBut in fact it is just an ordinary well."
	overworld_level.ui_layer.add_child(textbox)
	textbox.lines_to_move = 1
	textbox.text_display.time_between_chars = 0.02
	await textbox.textbox_done
	textbox.queue_free()
	for _i in range(2):
		await get_tree().process_frame
	player.controls_locked = false
