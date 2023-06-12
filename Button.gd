extends Button

onready var click = $AudioStreamPlayer
var is_down = false
var holdTimer = 0


func _process(delta: float) -> void:
	if pressed and $HoldDelay.is_stopped():
		holdTimer += delta
	else:
		holdTimer = 0
	if holdTimer >= Globals.gameState.holdClicksPerSec:
		holdTimer = 0
		emit_signal("pressed")
		play_click()


func _on_Button_button_down() -> void:
	if not is_down:
		$HoldDelay.start()
		play_click()
		rect_position.y += 4
	is_down = true


func _on_Button_button_up() -> void:
	is_down = false
	rect_position.y -= 4

func play_click():
	if not click.playing:
		click.pitch_scale = Constants.bluesFeqs[rand_range(0, Constants.bluesFeqs.size())] + 0.5
		click.play()

func notif_off():
	get_node("%Notifcation").visible = false
func notif_on():
	get_node("%Notifcation").visible = true
