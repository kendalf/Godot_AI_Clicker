extends Control

onready var tier_panel = preload("res://tierPanel2.tscn")
var tier_node_list = {}
var update_ui_timer = 0
signal notification

func _ready() -> void:
	for tier_res in Globals.generator_tiers.Tiers:
		var tier_node = tier_panel.instance()
		tier_node.get_node("%name").text = tier_res.Name
		tier_node.get_node("%Icon").texture = tier_res.Icon

		var infoButton = tier_node.get_node("%InfoIconButton")
		infoButton.connect("pressed", self, "info_button_pressed", [tier_res])

		var buyButton = tier_node.get_node("%buyButton")
		buyButton.connect("pressed", self, "buy_button_pressed", [tier_res])
		get_node("%TierPanelContainer").add_child(tier_node)
		tier_node_list[tier_res.Name] = tier_node
	update_ui()


func _process(delta: float) -> void:
	update_ui_timer += delta
	if update_ui_timer >= 0.2: #update 3 times a second
		update_ui_timer = 0
		update_ui()


func update_ui():
	for tier_res in Globals.generator_tiers.Tiers:
		var tier_node = tier_node_list[tier_res.Name]
		var price = tier_res.get_BigPrice()
		if tier_res.hidden:
			if Globals.gameState.get_currency().multiply(10).isLessThan(price):
				tier_node.visible = false
			elif tier_node.visible == false:
				if !tier_res.Locked:
					tier_node.visible = true
					emit_signal("notification")
					tier_res.hidden = false
		else:
			tier_node.visible = true
		var produces = tier_res.get_BigProduces()
		var total = Big.new(produces)
		total.multiply(tier_res.Owned)
		tier_node.get_node("%InfoIconButton").disabled = tier_res.Owned < 1
		var buyButton = tier_node.get_node("%buyButton")
		if Globals.gameState.get_currency().isLargerThanOrEqualTo(price):
			buyButton.disabled = false
		else:
			buyButton.disabled = true
		tier_node.get_node("%owned").text = str(tier_res.Owned) + " Owned"
		tier_node.get_node("%produces").text = "Produces: " + produces.toAA() + " cps"
		tier_node.get_node("%total").text = "Totaling: " + total.toAA() + " cps"
		var buyButtonLabel = buyButton.get_node("HBoxContainer/Price")
		buyButtonLabel.text = price.toAA()


func buy_button_pressed(tier_res):
	var price = tier_res.get_BigPrice()
	if Globals.gameState.get_currency().isLargerThanOrEqualTo(price):
		Globals.gameState.set_currency(Globals.gameState.get_currency().minus(price))
		var produces = tier_res.get_BigProduces()
		var newPerSec = Globals.gameState.get_perSec().plus(produces)
		Globals.gameState.set_perSec(newPerSec)
		Globals.gameState.numComputers +=1
		tier_res.buy()
		update_ui()

func info_button_pressed(tier_res) -> void:
	get_parent().get_node("%InfoCard").update_ui(tier_res)
	GuiTransitions.show("InfoCard")


func _on_back_pressed() -> void:
	GuiTransitions.hide("Tiers")
