class_name Achievment_Res
extends Resource

signal GotAchievement

export(String) var Name
export(Texture) var Icon
export(bool) var Hidden
export(bool) var Recived
export(bool) var Locked
export(bool) var NewNotif = false
export(Array, float) var Goal
export(Array, float) var Progress
export(int) var OCPoints
export(String, MULTILINE) var Description
export(String, MULTILINE) var PerkDescription


func is_goal_reached():
	var bigGoal = Big.new(Goal[0], Goal[1])
	var bigProgress = Big.new(Progress[0], Progress[1])
	return bigProgress.isLargerThanOrEqualTo(bigGoal)


func checkTrigger():
	if Recived:
		return false
	Recived = is_goal_reached()
	if Recived:
		NewNotif = true
		Hidden = false
		emit_signal("GotAchievement", self)
#		Globals.gameState.overClockPoints += PerkOCPoints
#		var perk = Big.new(Globals.gameState.get(PerkProperty))
#		perk.add(PerkValueToAdd)
#		if Globals.gameState.get(PerkProperty).get_class() != "Big":
#			perk = float(perk.toString())
#		Globals.gameState.set(PerkProperty, perk)
	return Recived

func get_progress():
	return Big.new(Progress[0], Progress[1])

func set_progress(newProg):
	var bigNewProg = Big.new(newProg)
	Progress[0] = bigNewProg.mantissa
	Progress[1] = bigNewProg.exponent
	checkTrigger()

func add_to_progress(num):
	num = Big.new(num)
	set_progress(get_progress().plus(num))


func get_progress_dict():
	var bigGoal = Big.new(Goal[0], Goal[1])
	var bigProgress = Big.new(Progress[0], Progress[1])
	bigProgress.divide(bigGoal)
	bigProgress.multiply(100)
	var dict = {
		"percent" : int(bigProgress.toString()),
		"bigProgress" : bigProgress,
		"bigGoal" : bigGoal,
		"string" :  Big.min(bigProgress, bigGoal).toAA() + " / " + bigGoal.toAA()
	}
	return dict

func update_from_dict(dict : Dictionary):
	Hidden = dict["Hidden"]
	Recived = dict["Recived"]
	Locked = dict["Locked"]
	Progress = dict["Progress"]


func get_save_dict():
	return {
		"Hidden" : Hidden,
		"Recived" : Recived,
		"Locked" : Locked,
		"Progress" : Progress
		}
