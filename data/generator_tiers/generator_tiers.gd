class_name Generators_Res_Array
extends Resource

signal ComputerBought
export(Array, Resource) var Tiers

func get_save_dict():
	var dict = {}
	for t in range(0, Tiers.size()):
		dict[Tiers[t].Name] = Tiers[t].get_save_dict()
	return dict

func update_from_dict(dict : Dictionary):
	for t in Tiers:
		t.update_from_dict(dict[t.Name])

func resetResources():
	for t in range(0, Tiers.size()):
		var path = String(Tiers[t].resource_path)
		Tiers[t].resource_path = ""
		Tiers[t] = ResourceLoader.load(path, "", true)


func connect_signals():
	for t in Tiers:
		t.connect("ComputerBought", self, "emitAchievSignal")

func emitAchievSignal(tier):
	emit_signal("ComputerBought", tier)
