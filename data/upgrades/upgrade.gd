class_name Upgrade
extends Resource

export(String) var Name
export(String) var InGameName
export(Texture) var Icon
export(Array, float) var BigPrice
export(bool) var recurring
export(bool) var hidden
export(float) var PriceMultiplier
export(int) var Owned
export(String, MULTILINE) var Description


func get_save_dict():
	return {
		"BigPrice" : BigPrice,
		"recurring" : recurring,
		"hidden" : hidden,
		"PriceMultiplier" : PriceMultiplier,
		"Owned" : Owned,
		"Description" : Description,
		}

func update_from_dict(dict : Dictionary):
	BigPrice = dict["BigPrice"]
	recurring = dict["recurring"]
	hidden = dict["hidden"]
	PriceMultiplier = dict["PriceMultiplier"]
	Owned = dict["Owned"]
	Description = dict["Description"]

func get_BigPrice():
	var price = Big.new(BigPrice[0], BigPrice[1])
	if Name == "MaxClickMultiplierUp":
		price.multiply(Globals.gameState.maxClickUpgradePriceMultiplier)
	return price.multiply(Globals.gameState.upgradePriceMultiplier)

func set_BigPrice(newBigPrice):
	BigPrice = [newBigPrice.mantissa, newBigPrice.exponent]

func do_upgrade(args := []):
	var price = get_BigPrice()
	if Globals.gameState.get_currency().isLargerThanOrEqualTo(price):
		Owned += 1
		Globals.gameState.upgradesBought += 1
		Globals.gameState.set_currency(Globals.gameState.get_currency().minus(price))
		price = Big.new(BigPrice[0], BigPrice[1])
		set_BigPrice(price.multiply(PriceMultiplier).roundDown())
		if not recurring:
			hidden = true
		call(Name + "_func", args)


func HoldToClick_func(_args):
	Globals.gameState.holdClicksPerSec = 0.5

func HoldToClickFaster_func(_args):
	Globals.gameState.holdClicksPerSec *= 0.8

func RandomClickEventMoreFrequent_func(_args):
	var wait = Globals.gameState.random_click_event_wait_range
	wait[0] *= 0.75
	wait[1] *= 0.75
	Globals.gameState.random_click_event_wait_range = wait

func RandomClickEventScaleMultiplier_func(_args):
	Globals.gameState.random_click_event_scale_multiplier += 1

func clickPercentCPS_func(_args):
	Globals.gameState.CPS_click_percent += 0.01
	var perc = (Globals.gameState.CPS_click_percent + 0.01) * 100
	var replacement = " " + str(perc) + "%"
	var regex = RegEx.new()
	regex.compile(" [0-9]+%")
	Description = regex.sub(Description, replacement)

func MaxClickMultiplierUp_func(_args):
	Globals.gameState.maxClickMultiplier += 1
