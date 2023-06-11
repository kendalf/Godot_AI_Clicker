extends PanelContainer

var update_ui_timer = 0

func _process(delta: float) -> void:
	update_ui_timer += delta
	if update_ui_timer >= 0.2: #update 3 times a second
		update_ui_timer = 0
		get_node("%OCPoints").text = str(Globals.gameState.overClockPoints)
