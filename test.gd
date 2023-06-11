extends Control

func _ready() -> void:
	$Control/Random_Click_Event.start()
	pass


func _on_Random_Click_Event_clicked(_args) -> void:
	print('clicked')
