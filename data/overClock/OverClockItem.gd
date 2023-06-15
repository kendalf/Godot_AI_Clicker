class_name OverClock_Item
extends Resource

export(String) var Name
export(Texture) var Icon
export(String, MULTILINE) var Description
export(Dictionary) var v = {
	"Hidden" : true,
	"Price" : 1,
	"AppliedPoints" : 0,
	"VarToSet" : "",
	"ValueToAdd" : 1.0,
	"Unit" : "%",
	"Max" : 0
}
export(String) var SciFiComp

func applyPerk():
	if Globals.gameState.overClockPoints >= v["Price"] \
					and v["AppliedPoints"] < v["Max"]:
		Globals.gameState.overClockPoints -= v["Price"]
		if SciFiComp != "":
			Globals.gameState.scifiComputers[SciFiComp] = 0
			update_scifiComp_res()
		else:
			var amount = Globals.gameState.get(v["VarToSet"]) + v["ValueToAdd"]
			Globals.gameState.set(v["VarToSet"], amount)
		v["AppliedPoints"] += v["Price"]

func unapplyPerk():
	if v["AppliedPoints"] >= v["Price"]:
		Globals.gameState.overClockPoints += v["Price"]
		if SciFiComp != "":
			Globals.gameState.scifiComputers[SciFiComp] = 1
			update_scifiComp_res()
		else:
			var amount = Globals.gameState.get(v["VarToSet"]) - v["ValueToAdd"]
			Globals.gameState.set(v["VarToSet"], amount)
		v["AppliedPoints"] -= v["Price"]

func update_scifiComp_res():
	for t in Globals.generator_tiers.Tiers:
		if t.Name == SciFiComp:
			t.Locked = Globals.gameState.scifiComputers[SciFiComp]
			print(t.Name)
			print(t.Locked)
			break
