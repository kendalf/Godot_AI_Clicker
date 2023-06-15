class_name GameState
extends Resource

export var runNumber = 1
export(int) var runStartTime = OS.get_unix_time()
export var numClicks = 0
export var CPS_click_percent = 0.0
export(Array) var totalComputations = [0,0]
export(Array) var currency = [0,0]
export(Array) var perClick = [1,0]
export(Array) var perSec = [0,0]
export var holdClicksPerSec = 1000
export var random_click_event_wait_range = [60, 120]
export var random_click_event_scale_multiplier = 2.5
export var random_click_event_clicked = 0
export var numComputers = 0
export var upgradesBought = 0
export var maxClickMultiplier = 1
export var maxClickUpgradePriceMultiplier = 1.0

export var achievmentsGot = 0
export var overClockPoints = 0
export var computerPriceMultiplier = 1.0
export(Dictionary) var computerProductionDoubles
export var upgradePriceMultiplier = 1.0
export var computerSpeedMultiplier = 1.0
export var offlineTimeLimit = 120
export var offlineRateMultiplier = 0.1
export(Dictionary) var scifiComputers = {
	"Boy Ratty"     : 1,
	"Steep Thought" : 1,
	"PAL9000"       : 1,
	"SkyWeb"        : 1,
	"The Vectorix"  : 1,
	"Beta"          : 1,
	"Multisnack"    : 1,
	"ZITT"          : 1,
	"Barvis"        : 1,
	"Vex"           : 1,
	"D-4PO"         : 1,
}

export var play_streak = 0
export var OC_given_per_24h = 0
export var timeSaved = 0
export var eventLog = []
export var settings = {
	"SFX" : 1,
	"Music" : 1,
	"Particles" : 1
}

#if its a differenct date and its been less than 24 hours since the
#last time played then you get +1 to the play_streak var
func compute_daily_streak():
	var today = Time.get_datetime_dict_from_unix_time(OS.get_unix_time())
	var dayLastPlayed = Time.get_datetime_dict_from_unix_time(timeSaved)
	if today["day"] != dayLastPlayed["day"]:
		var secs = OS.get_unix_time() - timeSaved #get seconds since last played
		var days = secs / 60 / 60 / 24 #days since last played
		if days > 1:
			play_streak = 1
		else:
			play_streak+= 1

func compute_offline_earnings():
	var timeDif = OS.get_unix_time() - timeSaved #seconds since last played
	#apply offline time limit
	timeDif = min(timeDif / 60, offlineTimeLimit) * 60
	var earned = get_perSec().multiply(timeDif)
	earned.multiply(offlineRateMultiplier) #apply offline rate
	set_currency(get_currency().plus(earned))
	return earned

func compute_OC_earnings():
	var oc = int((get_hours_played_int() / 24.0) - OC_given_per_24h)
	if oc >= 1:
		OC_given_per_24h += oc
		overClockPoints += oc
		return oc
	return 0

func get_hours_played_int():
	var hoursPlayed = Time.get_time_dict_from_unix_time(OS.get_unix_time() - runStartTime)
	return hoursPlayed["hour"]

func get_hours_played():
	var hoursPlayed = Time.get_time_string_from_unix_time(OS.get_unix_time() - runStartTime)
	hoursPlayed = str(hoursPlayed).substr(0, 5)
	return hoursPlayed

func get_save_dict():
	return {
		"runNumber" : runNumber,
		"runStartTime" : runStartTime,
		"numClicks" : numClicks,
		"CPS_click_percent" : CPS_click_percent,
		"totalComputations" : totalComputations,
		"currency" : currency,
		"perClick" : perClick,
		"perSec" : perSec,
		"holdClicksPerSec" : holdClicksPerSec,
		"random_click_event_wait_range" : random_click_event_wait_range,
		"random_click_event_scale_multiplier" : random_click_event_scale_multiplier,
		"random_click_event_clicked" : random_click_event_clicked,
		"numComputers" : numComputers,
		"achievmentsGot" : achievmentsGot,
		"upgradesBought" : upgradesBought,
		"maxClickMultiplier" : maxClickMultiplier,
		"maxClickUpgradePriceMultiplier" : maxClickUpgradePriceMultiplier,

		"overClockPoints" : overClockPoints,
		"computerPriceMultiplier" : computerPriceMultiplier,
		"computerProductionDoubles" : computerProductionDoubles,
		"upgradePriceMultiplier" : upgradePriceMultiplier,
		"computerSpeedMultiplier" : computerSpeedMultiplier,
		"offlineTimeLimit" : offlineTimeLimit,
		"offlineRateMultiplier" : offlineRateMultiplier,
		"scifiComputers" : scifiComputers,

		"play_streak" : play_streak,
		"OC_given_per_24h" : OC_given_per_24h,
		"timeSaved" : timeSaved,
		"eventLog" : eventLog,
		"settings" : settings
		}

func update_from_dict(dict : Dictionary):
	runNumber = dict["runNumber"]
	runStartTime = dict["runStartTime"]
	numClicks = dict["numClicks"]
	CPS_click_percent = dict["CPS_click_percent"]
	totalComputations = dict["totalComputations"]
	currency = dict["currency"]
	perClick = dict["perClick"]
	perSec = dict["perSec"]
	holdClicksPerSec = dict["holdClicksPerSec"]
	random_click_event_wait_range = dict["random_click_event_wait_range"]
	random_click_event_scale_multiplier = dict["random_click_event_scale_multiplier"]
	random_click_event_clicked = dict["random_click_event_clicked"]
	numComputers = dict["numComputers"]
	achievmentsGot = dict["achievmentsGot"]
	upgradesBought = dict["upgradesBought"]
	maxClickMultiplier = dict["maxClickMultiplier"]
	maxClickUpgradePriceMultiplier = dict["maxClickUpgradePriceMultiplier"]

	overClockPoints = dict["overClockPoints"]
	computerPriceMultiplier = dict["computerPriceMultiplier"]
	computerProductionDoubles = dict["computerProductionDoubles"]
	upgradePriceMultiplier = dict["upgradePriceMultiplier"]
	computerSpeedMultiplier = dict["computerSpeedMultiplier"]
	offlineTimeLimit = dict["offlineTimeLimit"]
	offlineRateMultiplier = dict["offlineRateMultiplier"]
	scifiComputers = dict["scifiComputers"]

	play_streak = dict["play_streak"]
	OC_given_per_24h = dict["OC_given_per_24h"]
	timeSaved = dict["timeSaved"]
	eventLog = dict["eventLog"]
	settings = dict["settings"]


func get_totalComputations():
	return Big.new(totalComputations[0],totalComputations[1])

func set_totalComputations(big_num : Big):
	totalComputations = [big_num.mantissa, big_num.exponent]

func addTo_totalComputations(num):
	set_totalComputations(get_totalComputations().plus(Big.new(num)))

func get_currency():
	return Big.new(currency[0],currency[1])

func set_currency(num):
	var big_num = Big.new(num)
	if big_num.isLargerThan(get_currency()):
		var sub = Big.new(big_num).minus(get_currency())
		addTo_totalComputations(sub)
	currency = [big_num.mantissa, big_num.exponent]

func addTo_currency(num):
	set_currency(get_currency().plus(Big.new(num)))

func get_perClick():
	return Big.new(perClick[0],perClick[1])

func set_perClick(big_num : Big):
	perClick = [big_num.mantissa, big_num.exponent]

func get_perSec():
	return Big.new(perSec[0],perSec[1])

func set_perSec(big_num : Big):
	perSec = [big_num.mantissa, big_num.exponent]

func addTo_perSec(num):
	set_perSec(get_perSec().plus(num))

func recalc_perSec():
	var newValue = Big.new(0)
	for t in Globals.generator_tiers.Tiers:
		newValue.plus(t.get_BigProduces().multiply(t.Owned))
	print(newValue.toAA())
	perSec = [newValue.mantissa, newValue.exponent]
