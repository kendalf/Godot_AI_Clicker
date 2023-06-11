class_name Generator_Tier
extends Resource

signal ComputerBought

export(String) var Name
export(Texture) var Icon
export(Array, float) var BigPrice = [1.0, 1.0]
export(Array, float) var BigProduces = [1.0, 1.0]
export(float) var GenSpeed # unused
export(float) var PriceMultiplier = 1.09
export(bool) var hidden = false
export(int) var Owned
export(bool) var Locked
export(String, MULTILINE) var Description
export(String, MULTILINE) var LongDescription


func get_BigPrice():
	var multi = max(Globals.gameState.computerPriceMultiplier, 0.01)
	return Big.new(BigPrice[0], BigPrice[1]).multiply(multi)

func set_BigPrice(newBigPrice):
	BigPrice = [newBigPrice.mantissa, newBigPrice.exponent]

func get_BigProduces():
	return Big.new(BigProduces[0], BigProduces[1]).multiply(Globals.gameState.computerSpeedMultiplier)

func set_BigProduces(newBigProduces):
	BigProduces = [newBigProduces.mantissa, newBigProduces.exponent]


func buy():
	var price = Big.new(BigPrice[0], BigPrice[1])
	Owned += 1
	price.multiply(PriceMultiplier).roundDown()
	set_BigPrice(price)
	emit_signal("ComputerBought", self)


func get_save_dict():
	return {
		"BigPrice" : BigPrice,
		"BigProduces" : BigProduces,
		"PriceMultiplier" : PriceMultiplier,
		"hidden" : hidden,
		"Owned" : Owned
		}

func update_from_dict(dict : Dictionary):
	BigPrice = dict["BigPrice"]
	BigProduces = dict["BigProduces"]
	PriceMultiplier = dict["PriceMultiplier"]
	hidden = dict["hidden"]
	Owned = dict["Owned"]
