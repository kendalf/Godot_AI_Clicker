extends Control

onready var upgrade_panel = preload("res://upgradePanel.tscn")
var tier_node_list = {}
var update_ui_timer = 0
signal notification

func _ready() -> void:
	for upgrade_res in Globals.upgrades.list:
		var upgrade_node = upgrade_panel.instance()
		upgrade_node.get_node("%name").text = upgrade_res.InGameName
		upgrade_node.get_node("%Icon").texture = upgrade_res.Icon
		var buyButton = upgrade_node.get_node("%buyButton")
		buyButton.connect("pressed", self, "buy_button_pressed", [upgrade_res])
		get_node("%UpgradePanelContainer").add_child(upgrade_node)
		tier_node_list[upgrade_res.Name] = upgrade_node
	update_ui()


func _process(delta: float) -> void:
	update_ui_timer += delta
	if update_ui_timer >= 0.2: #update 3 times a second
		update_ui_timer = 0
		update_ui()


func update_ui():
	for upgrade_res in Globals.upgrades.list:
		var upgrade_node = tier_node_list[upgrade_res.Name]
		upgrade_node.get_node("%description").text = upgrade_res.Description
		var price = upgrade_res.get_BigPrice()
		var canAfford = !Globals.gameState.get_currency().multiply(10).isLessThan(price)

		if canAfford and upgrade_res.hidden:
			if upgrade_res.Owned == 0 or upgrade_res.recurring:
				emit_signal("notification")
				upgrade_res.hidden = false
		upgrade_node.visible = !upgrade_res.hidden

		var buyButton = upgrade_node.get_node("%buyButton")
		if Globals.gameState.get_currency().isLargerThanOrEqualTo(price):
			buyButton.disabled = false
		else:
			buyButton.disabled = true
		var buyButtonLabel = buyButton.get_node("HBoxContainer/Price")
		buyButtonLabel.text = price.toAA()


func buy_button_pressed(upgrade_res):
		upgrade_res.do_upgrade()
		update_ui()


func _on_back_pressed() -> void:
# warning-ignore:return_value_discarded
	GuiTransitions.hide(self.name)
