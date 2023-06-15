extends Control

onready var achiev_panel = preload("res://AchievPanel.tscn")
var achiev_nodes = {}
signal rewardGot

func _ready() -> void:
	for achiev_res in Globals.achievements.list:
		if not achiev_res.Hidden or achiev_res.Recived:
			var achiev_node = achiev_panel.instance()
			achiev_node.icon = achiev_res.Icon
			achiev_node.get_node("%Goal").text = achiev_res.checkProgress()["bigGoal"].toAA()
			get_node("%GridContainer").add_child(achiev_node)
			achiev_nodes[achiev_res.Name] = achiev_node
			if achiev_res.NewNotif:
				achiev_node.get_node("%Notification").visible = true
			if not achiev_res.Recived:
				achiev_node.modulate.a = 0.25
			achiev_node.connect("button_down", get_node("%AchievementDetails"), "show_details", [achiev_res])
			achiev_node.connect("unpressed", get_node("%AchievementDetails"), "hide_details")


func update_ui():
	for achiev_res in Globals.achievements.list:
		var achiev_node = achiev_nodes[achiev_res.Name]
		if achiev_res.NewNotif:
			achiev_node.get_node("%Notification").visible = true
		if not achiev_res.Hidden or achiev_res.Recived:
			if not achiev_res.Recived:
				achiev_node.modulate.a = 0.25
			else:
				achiev_node.modulate.a = 1.0


func _on_back_pressed() -> void:
	GuiTransitions.hide(self.name)


func _on_AchievementDetails_rewardGot(achiev_res) -> void:
	achiev_nodes[achiev_res.Name].get_node("%Notification").visible = false
	emit_signal("rewardGot")
