class_name OverClock_Res_Array
extends Resource

export(Array, Resource) var list
export(Array, Resource) var comp


func get_save_dict():
	var dict = {}
	for o in list:
		dict[o.Name] = o.v
	return dict

func update_from_dict(dict : Dictionary):
	for o in list:
		o.v = dict[o.Name]
