extends Panel

onready var I = Constants.ICON
var currently_selected : Resource
const UPDATE_INTERVAL = 1
var updateTimer = 0

func _ready() -> void:
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



func _process(delta: float) -> void:
	if currently_selected:
		updateTimer += delta
	if updateTimer >= UPDATE_INTERVAL:
		updateTimer = 0
		update_details(currently_selected)
