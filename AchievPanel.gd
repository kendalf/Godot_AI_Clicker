extends Button

signal unpressed

func _ready() -> void:
	pass

func _on_AchievPanel_toggled(button_pressed: bool) -> void:
	if button_pressed:
		get_node("%OutLine").visible = true
	else:
		emit_signal("unpressed")
		get_node("%OutLine").visible = false

func _on_AchievPanel_focus_exited() -> void:
	self.pressed = false
