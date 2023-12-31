extends Container

onready var I = Constants.ICON
var currently_selected : Resource
const UPDATE_INTERVAL = 1
var updateTimer = 0
signal rewardGot
onready var Osize = rect_size
onready var Opos = rect_position
onready var Omod = modulate

func _ready() -> void:
	self.visible = false
	pass

func update_details(achiev_res):
	currently_selected = achiev_res
	get_node("%DetailDescription").text =  achiev_res.Description
	var text = get_node("%Perks")
	text.clear()
	text.append_bbcode("Reward: +" + str(achiev_res.OCPoints) + " ")
	text.add_image(I["chip"], 40, 40, 1)
	if achiev_res.PerkDescription != "":
		text.newline()
		text.push_indent(1)
		text.append_bbcode(achiev_res.PerkDescription)
	get_node("%DetailIcon").texture = achiev_res.Icon
	var progress = achiev_res.checkProgress()
	get_node("%DetailProgress").value = progress["percent"]
	get_node("%ProgressLabel").text = progress["string"]
	get_node("%RewardButton").disabled = !achiev_res.NewNotif
	get_node("%RewardButton").visible = achiev_res.NewNotif

func show_details(achiev_res):
	update_details(achiev_res)
	bounce()

func hide_details():
	self.visible = false

func _process(delta: float) -> void:
	if currently_selected:
		updateTimer += delta
	if updateTimer >= UPDATE_INTERVAL:
		updateTimer = 0
		update_details(currently_selected)

func _on_RewardButton_pressed() -> void:
	currently_selected.complete()
	update_details(currently_selected)
	emit_signal("rewardGot", currently_selected)

func bounce():
	self.visible = true
	rect_position = Opos
	$Tween.interpolate_property(self, "rect_position", Vector2.ZERO, rect_position, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
