extends PopupPanel

var currentOkConnection = {}

func _ready() -> void:
	pass


func update_content(data : Dictionary):
	get_node("%Image").texture = load(data["Image"])
	get_node("%Title").text = data["Title"]
	get_node("%Message").bbcode_text = data["Message"]
	get_node("%NoThanks").visible = data["NoThanks"]
	if currentOkConnection.has("node"):
		get_node("%OK").disconnect("pressed", currentOkConnection["node"], currentOkConnection["func"])
		currentOkConnection = {}
	if data.has("callFunc"):
		currentOkConnection["node"] = data["callNode"]
		currentOkConnection["func"] = data["callFunc"]
		var _result = get_node("%OK").connect("pressed", data["callNode"], data["callFunc"], [data["args"]])


func _on_NoThanks_pressed() -> void:
	self.visible = false


func _on_OK_pressed() -> void:
	self.visible = false
