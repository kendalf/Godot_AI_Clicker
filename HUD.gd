extends Panel

onready var temp_currency = Big.new(0)

var currency_timer = 0


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	temp_currency.plus(Globals.gameState.get_perSec().multiply(delta))
	currency_timer += delta
	if currency_timer >= 0.0416: #update every 24th of a second
		currency_timer = 0
		update_hud()


func update_hud():
	var temp_decimal = 0.0
	temp_decimal = fmod(temp_currency.mantissa, 1.0)
	temp_currency.mantissa = floor(temp_currency.mantissa)
	Globals.gameState.set_currency(Globals.gameState.get_currency().plus(temp_currency))
	temp_currency = Big.new(temp_decimal)
	var string = ""
	if Globals.gameState.get_currency().exponent >= 3:
		string = Globals.gameState.get_currency().toAA(false, true, true)
	else:
		string = Globals.gameState.get_currency().toAA()
	$Money.text = string + "\n"
	$Money/cps.text = Globals.gameState.get_perSec().toAA() + " cps"
