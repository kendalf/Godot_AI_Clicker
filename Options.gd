extends Control

signal Toggle_Particles

func _ready() -> void:
	get_node("%Particles").pressed = Globals.gameState.settings["Particles"]

func _on_back_pressed() -> void:
	GuiTransitions.hide(self.name)



func _on_Particles_toggled(button_pressed: bool) -> void:
	Globals.gameState.settings["Particles"] = button_pressed
	emit_signal("Toggle_Particles", button_pressed)
