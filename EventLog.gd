extends Panel

signal openLog

func _ready() -> void:
	visible = false
#	var canvas_rid = get_canvas_item()
#	VisualServer.canvas_item_set_draw_index(canvas_rid, 100)
#	VisualServer.canvas_item_set_z_index(canvas_rid, 100)
#	if Globals.gameState.eventLog == []:
#		visible = false
#	else:
#		var events = [] + Globals.gameState.eventLog
#		Globals.gameState.eventLog = []
#		for e in events:
#			add_event(e)


func _on_Clear_pressed() -> void:
	get_node("%Buttons").visible = false
	get_node("%Events").bbcode_text = ""
	Globals.gameState.eventLog = []
	$Anim.play_backwards("Expand")
	yield($Anim, "animation_finished")
	$Anim.play_backwards("PopIn")
	yield($Anim, "animation_finished")
	visible = false


func add_event(event, notif := false, icon := "res://images/perceptron-export.png"):
	get_node("%EventIcon").texture = load(icon)
	get_node("%Marquee").start(event)
	if notif:
		$notification.visible = true
	$Anim.play("PopIn")
	visible = true
	Globals.gameState.eventLog.push_front("[cell][img=30]" + icon + "[/img][/cell]" + "[cell]" + event + "\n[/cell]")
	var text = "[table=2]"
	for x in Globals.gameState.eventLog:
		text += x + "\n"
	text += "[/table]"
	get_node("%Events").bbcode_text = text


func _on_EventLog_focus_exited() -> void:
	get_node("%TickerBox").visible = true
	get_node("%Events").visible = false
	get_node("%Events").scroll_to_line(0)
	get_node("%Buttons").visible = false
	$Anim.play_backwards("Expand")


func _on_EventLog_focus_entered() -> void:
	emit_signal("openLog")
	get_node("%TickerBox").visible = false
	get_node("%Events").visible = true
	$notification.visible = false
	get_node("%Buttons").visible = true
	$Anim.play("Expand")
