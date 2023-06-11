extends Control

var labelText = ""

func _ready() -> void:
	pass

func start(new_text):
	labelText = new_text
	self.text = new_text
	$StartTimer.start()
	$ScrollTimer.stop()


func _on_StartTimer_timeout() -> void:
	$ScrollTimer.start()


func _on_ScrollTimer_timeout() -> void:
	if self.visible:
		if self.text.length() >= 1:
			self.text = self.text.substr(1)
		else:
			start(labelText)
