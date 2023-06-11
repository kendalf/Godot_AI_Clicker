class_name Achievement_Manager
extends Resource

#signal GotAchievement

export(Array, Resource) var list

func _ready() -> void:
#	Globals.achievements.connect("GotAchievement", self, "got_Achievement")
	Globals.generator_tiers.connect("ComputerBought", self, "ComputersOwned")


func get_save_dict():
	var dict = {}
	for a in list:
		dict[a.Name] = a.get_save_dict()
	return dict

func update_from_dict(dict : Dictionary):
	for a in list:
		a.update_from_dict(dict[a.Name])


func connect_signals():
	for a in list:
		a.connect("GotAchievement", self, "got_Achievement")

#func emitAchievSignal(achiev):
#	emit_signal("GotAchievement", achiev)


func got_Achievement(achiev):
	Globals.gameState.overClockPoints += achiev.PerkOCPoints
	call("got_" + achiev.Name, achiev)

func got_10Achievements(achiev):
	return

func got_25Computers(achiev):
	Globals.gameState.computerPriceMultiplier += -0.01

func ComputersOwned(tier):
	for a in list:
		if a.Name == "25Computers":
			a.add_to_progress(1)
		if a.Name == "25" + a.Name:
			a.add_to_progress(1)

	#find computers owned achievments and update their progress
	Globals.gameState.computerPriceMultiplier += -0.01
