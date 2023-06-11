extends Control

func _ready() -> void:
	pass

func update_ui(tier_res):
	get_node("%Title").text = tier_res.Name
	get_node("%Portrait").texture = tier_res.Icon
	var produces = tier_res.get_BigProduces()
	var total = Big.new(produces)
	total.multiply(tier_res.Owned)
	get_node("%owned").text = str(tier_res.Owned) + " Owned"
	get_node("%produces").text = "Produces: " + produces.toAA() + " cps"
	get_node("%total").text = "Totaling: " + total.toAA() + " cps"
	get_node("%LongDescription").text = tier_res.LongDescription
	get_node("%LongDescription").scroll_to_line(0)


func _on_back_pressed() -> void:
	GuiTransitions.hide(self.name)
