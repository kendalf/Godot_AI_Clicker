extends Control

onready var panel = preload("res://PresteigeItemPanel.tscn")

var nodeList = {}
var update_ui_timer = 0

func _ready() -> void:
	for i in Globals.OCList.list:
		get_panel_ready(i)
	for c in Globals.OCList.comp:
		get_panel_ready(c, true)

func update_ui():
	for i in Globals.OCList.list:
		update_panel(i)
	for c in Globals.OCList.comp:
		update_panel(c, true)

func get_panel_ready(res, _comp := false):
		var panelNode = panel.instance()
		panelNode.get_node("%Up").connect("pressed", self, "up_button_pressed", [res])
		panelNode.get_node("%Down").connect("pressed", self, "down_button_pressed", [res])
		get_node("%ItemContainer").add_child(panelNode)
		nodeList[res.Name] = panelNode

func update_panel(res, _comp := false):
	var panelNode = nodeList[res.Name]
	panelNode.get_node("%ItemName").text = res.Name
	panelNode.get_node("%Price").text = "x" + str(res.v["Price"])
	panelNode.get_node("%Icon").texture = res.Icon
	panelNode.get_node("%Description").text = res.Description
	if res.v.has("Unit"):
		var current = Globals.gameState.get(res.v["VarToSet"])
		if res.v["Unit"] == "%":
			current *= 100
		panelNode.get_node("%CurrentAmount").text = "Currently " + str(current) + res.v["Unit"]
	var upButton = panelNode.get_node("%Up")
	var downButton = panelNode.get_node("%Down")
	upButton.disabled = Globals.gameState.overClockPoints < res.v["Price"]
	downButton.disabled = res.v["AppliedPoints"] < res.v["Price"]

func _process(delta: float) -> void:
	update_ui_timer += delta
	if update_ui_timer >= 0.2: #update 3 times a second
		update_ui_timer = 0
		update_ui()

func up_button_pressed(res):
		res.applyPerk()

func down_button_pressed(res):
		res.unapplyPerk()

func _on_Done_pressed() -> void:
	GuiTransitions.hide(self.name)
	Globals.reset_run()
