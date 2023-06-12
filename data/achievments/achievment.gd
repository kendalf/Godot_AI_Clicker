class_name Achievment
extends Resource

export(String) var Name
export(Texture) var Icon
export(bool) var Hidden
export(bool) var Recived
export(bool) var NewNotif = false
export(int) var OCPoints = 1
export(String, MULTILINE) var Description
export(String, MULTILINE) var PerkDescription


func checkTrigger():
	if Recived:
		return false
	var progress = checkProgress()
	Recived = progress["percent"] >= 100
	if Recived:
		NewNotif = true
		Hidden = false
	return Recived

func extract_digits_from_name():
	var goal = Name.substr(0, Name.length() - 3).to_int()
	var index = Name.substr(Name.length()-3).to_int()
	return {"goal" : goal, "index" : index}

func checkProgress():
	if Name.match("Own*Tier*"):
		return OwnNumTier_progress()
	return call(Name + "_progress")

func complete():
	if !NewNotif: return #checks to see if they got the achievement
	NewNotif = false
	Globals.gameState.overClockPoints += OCPoints
	if Name.match("Own*Tier*"):
		return OwnNumTier_complete()
	return call(Name + "_complete")

func get_progress_dict(num, goal):
	var bigGoal = Big.new(goal)
	var bigNum = Big.new(num)
	var percent = Big.new(num)
	if bigNum.isLargerThanOrEqualTo(bigGoal):
		percent = 100
	else:
		percent.divide(bigGoal)
		percent.multiply(100)
		percent = percent.toString().to_int()
	var dict = {
		"percent" : percent,
		"bigNum" : bigNum,
		"bigGoal" : bigGoal,
		"string" :  Big.min(bigNum, bigGoal).toAA() + " / " + bigGoal.toAA()
	}
	return dict

func update_from_dict(dict : Dictionary):
	Hidden = dict["Hidden"]
	Recived = dict["Recived"]

func get_save_dict():
	return {
		"Hidden" : Hidden,
		"Recived" : Recived
		}

func allState():
	return Globals.get_current_allTime_gameState()
func gameState():
	return Globals.gameState
func getComps():
	return Globals.generator_tiers.Tiers


func clickPercentCPS_func(_args):
	Globals.gameState.CPS_click_percent += 0.01
	var perc = (Globals.gameState.CPS_click_percent + 0.01) * 100
	var replacement = " " + str(perc) + "%"
	var regex = RegEx.new()
	regex.compile(" [0-9]+%")
	Description = regex.sub(Description, replacement)


func recudce_maxClickUpgradePriceMultiplier_price():
	gameState().maxClickUpgradePriceMultiplier *= 0.75
#	for i in Globals.upgrades.list:
#		if i.Name == "MaxClickMultiplierUp":
##			i.set_BigPrice(i.get_BigPrice().multiply(gameState().maxClickUpgradePriceMultiplier))
#			break

func clickNum128_progress():
	return get_progress_dict(allState().numClicks, Big.new(128))
func clickNum128_complete():
	recudce_maxClickUpgradePriceMultiplier_price()

func clickNum1k_progress():
	return get_progress_dict(allState().numClicks, Big.new(1,3))
func clickNum1k_complete():
	recudce_maxClickUpgradePriceMultiplier_price()

func clickNum4k_progress():
	return get_progress_dict(allState().numClicks, Big.new(4,3))
func clickNum4k_complete():
	recudce_maxClickUpgradePriceMultiplier_price()

func clickNum8k_progress():
	return get_progress_dict(allState().numClicks, Big.new(8,3))
func clickNum8k_complete():
	recudce_maxClickUpgradePriceMultiplier_price()

func clickNum16k_progress():
	return get_progress_dict(allState().numClicks, Big.new(16,3))
func clickNum16k_complete():
	recudce_maxClickUpgradePriceMultiplier_price()




func numComputers32_progress():
	return get_progress_dict(allState().numComputers, 32)
func numComputers32_complete():
	gameState().computerPriceMultiplier -= 0.01

func numComputers256_progress():
	return get_progress_dict(allState().numComputers, 256)
func numComputers256_complete():
	gameState().computerPriceMultiplier -= 0.02

func numComputers1k_progress():
	return get_progress_dict(allState().numComputers, Big.new(1,3))
func numComputers1k_complete():
	gameState().computerPriceMultiplier -= 0.03




func randomClickEventClicked8_progress():
	return get_progress_dict(allState().random_click_event_clicked, 8)
func randomClickEventClicked8_complete():
	var wait = gameState().random_click_event_wait_range
	wait[0] *= 0.90
	wait[1] *= 0.90
	gameState().random_click_event_wait_range = wait

func randomClickEventClicked32_progress():
	return get_progress_dict(allState().random_click_event_clicked, 32)
func randomClickEventClicked32_complete():
	var wait = gameState().random_click_event_wait_range
	wait[0] *= 0.85
	wait[1] *= 0.85
	gameState().random_click_event_wait_range = wait

func randomClickEventClicked128_progress():
	return get_progress_dict(allState().random_click_event_clicked, 128)
func randomClickEventClicked128_complete():
	var wait = gameState().random_click_event_wait_range
	wait[0] *= 0.75
	wait[1] *= 0.75
	gameState().random_click_event_wait_range = wait

func randomClickEventClicked256_progress():
	return get_progress_dict(allState().random_click_event_clicked, 256)
func randomClickEventClicked256_complete():
	var wait = gameState().random_click_event_wait_range
	wait[0] *= 0.75
	wait[1] *= 0.75
	gameState().random_click_event_wait_range = wait

func randomClickEventClicked512_progress():
	return get_progress_dict(allState().random_click_event_clicked, 512)
func randomClickEventClicked512_complete():
	var wait = gameState().random_click_event_wait_range
	wait[0] *= 0.75
	wait[1] *= 0.75
	gameState().random_click_event_wait_range = wait




func CPS128_progress():
	return get_progress_dict(allState().get_perSec(), Big.new(128))
func CPS128_complete():
	gameState().computerSpeedMultiplier += 0.01

func CPS1k_progress():
	return get_progress_dict(allState().get_perSec(), Big.new(1, 3))
func CPS1k_complete():
	gameState().computerSpeedMultiplier += 0.02

func CPS8k_progress():
	return get_progress_dict(allState().get_perSec(), Big.new(8, 3))
func CPS8k_complete():
	gameState().computerSpeedMultiplier += 0.03

func CPS64k_progress():
	return get_progress_dict(allState().get_perSec(), Big.new(64, 3))
func CPS64k_complete():
	gameState().computerSpeedMultiplier += 0.04

func CPS512k_progress():
	return get_progress_dict(allState().get_perSec(), Big.new(512, 3))
func CPS512k_complete():
	gameState().computerSpeedMultiplier += 0.05




func totalComputations8k_progress():
	return get_progress_dict(allState().get_totalComputations(), Big.new(8, 3))
func totalComputations8k_complete():
	gameState().offlineRateMultiplier += 0.01

func totalComputations64k_progress():
	return get_progress_dict(allState().get_totalComputations(), Big.new(64, 3))
func totalComputations64k_complete():
	gameState().offlineRateMultiplier += 0.02

func totalComputations512k_progress():
	return get_progress_dict(allState().get_totalComputations(), Big.new(512, 3))
func totalComputations512k_complete():
	gameState().offlineRateMultiplier += 0.03

func totalComputations4m_progress():
	return get_progress_dict(allState().get_totalComputations(), Big.new(4, 6))
func totalComputations4m_complete():
	gameState().offlineRateMultiplier += 0.04


func achievementsGot8_progress():
	return get_progress_dict(allState().achievmentsGot, 8)
func achievementsGot8_complete():
	gameState().offlineTimeLimit += 15

func achievementsGot16_progress():
	return get_progress_dict(allState().achievmentsGot, 16)
func achievementsGot16_complete():
	gameState().offlineTimeLimit += 30

func achievementsGot32_progress():
	return get_progress_dict(allState().achievmentsGot, 32)
func achievementsGot32_complete():
	gameState().offlineTimeLimit += 45


func upgradesBought8_progress():
	return get_progress_dict(allState().upgradesBought, 8)
func upgradesBought8_complete():
	gameState().upgradePriceMultiplier -= 0.01

func upgradesBought32_progress():
	return get_progress_dict(allState().upgradesBought, 32)
func upgradesBought32_complete():
	gameState().upgradePriceMultiplier -= 0.02

func upgradesBought64_progress():
	return get_progress_dict(allState().upgradesBought, 64)
func upgradesBought64_complete():
	gameState().upgradePriceMultiplier -= 0.05


func OwnNumTier_progress():
	var index = extract_digits_from_name()["index"]
	var goal = extract_digits_from_name()["goal"]
	return get_progress_dict(getComps()[index].Owned, goal)

func OwnNumTier_complete():
	var index = extract_digits_from_name()["index"]
	var compName = getComps()[index].Name
	#add an entry to the global dict
	if !gameState().computerProductionDoubles.has(compName):
		gameState().computerProductionDoubles[compName] = 0
	gameState().computerProductionDoubles[compName] += 1
	#double the production of the computers that already exist
	gameState().addTo_perSec(getComps()[index].get_BigProduces().multiply(getComps()[index].Owned))
	#set the produciton rate of any new computers bought
	var newProduces = getComps()[index].get_BigProduces().multiply(2)
	getComps()[index].set_BigProduces(newProduces)
