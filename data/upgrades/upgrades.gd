class_name Upgrades
extends Resource

export(Array, Resource) var list

func get_save_dict():
	var dict = {}
	for u in range(0, list.size()):
		dict[list[u].Name] = list[u].get_save_dict()
	return dict

func update_from_dict(dict : Dictionary):
	for u in list:
		u.update_from_dict(dict[u.Name])

func resetResources():
	for u in range(0, list.size()):
		var path = String(list[u].resource_path)
		list[u].resource_path = ""
		list[u] = ResourceLoader.load(path, "", true)
