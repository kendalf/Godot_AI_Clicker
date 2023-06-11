class_name Upgrade_Res
extends Resource

export(String) var Name
export(Texture) var Icon
export(Array, float) var BigPrice
export(bool) var Recurring
export(bool) var Hidden
export(float) var PriceMultiplier
export(int) var Owned
export(Array, Dictionary) var PropertiesToUpgrade = [{
	"prop": "",
	"method": "",
	"value": ""
}]
export(String, MULTILINE) var Description


func get_save_dict():
	return {
		"BigPrice" : BigPrice,
		"Recurring" : Recurring,
		"Hidden" : Hidden,
		"PriceMultiplier" : PriceMultiplier,
		"Owned" : Owned
		}

func update_from_dict(dict : Dictionary):
	BigPrice = dict["BigPrice"]
	Recurring = dict["Recurring"]
	Hidden = dict["Hidden"]
	PriceMultiplier = dict["PriceMultiplier"]
	Owned = dict["Owned"]

func get_BigPrice():
	return Big.new(BigPrice[0], BigPrice[1]).multiply(Globals.gameState.upgradePriceMultiplier)

func set_BigPrice(newBigPrice):
	BigPrice = [newBigPrice.mantissa, newBigPrice.exponent]

func do_upgrade():
	for i in range(PropertiesToUpgrade.size()):
		var prop = PropertiesToUpgrade[i]["prop"]
		var method = PropertiesToUpgrade[i]["method"]
		var value = PropertiesToUpgrade[i]["value"]
		var p = Big.new(Globals.gameState.get(prop))
		p.call(method, value)
		if Globals.gameState.get(prop).get_class() != "Big":
			p = float(p.toString())
		Globals.gameState.set(prop, p)
