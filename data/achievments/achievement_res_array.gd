class_name Achievements_Res_Array
extends Resource

export(Array, Resource) var list

func get_save_dict():
	var dict = {}
	for a in list:
		dict[a.Name] = a.get_save_dict()
	return dict

func update_from_dict(dict : Dictionary):
	for a in list:
		a.update_from_dict(dict[a.Name])


