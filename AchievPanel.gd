extends Button


func _ready() -> void:
	pass

func _on_AchievPanel_focus_exited() -> void:
	get_node("%OutLine").visible = false
	self.pressed = false


func _on_AchievPanel_focus_entered() -> void:
	get_node("%OutLine").visible = true
