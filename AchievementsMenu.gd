extends Control

onready var achiev_panel = preload("res://AchievPanel.tscn")

func _ready() -> void:
	for achiev_res in Globals.achievements.list:
		if not achiev_res.Hidden or achiev_res.Recived:
			var achiev_node = achiev_panel.instance()
			achiev_node.icon = achiev_res.Icon
			achiev_node.get_node("%Goal").text = achiev_res.checkProgress()["bigGoal"].toAA()
			get_node("%GridContainer").add_child(achiev_node)
			if not achiev_res.Recived:
				achiev_node.modulate.a = 0.25
			achiev_node.connect("button_down", get_node("%AchievementDetails"), "update_details", [achiev_res])

func update_ui():
	for node in get_node("%GridContainer").get_children():
		node.queue_free()
	_ready()


func _on_back_pressed() -> void:
	GuiTransitions.hide(self.name)
