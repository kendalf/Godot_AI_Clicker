class_name Property_Hook
extends Node


export(String) var Property
export(String) var ObjOfProp
export(String) var Method
export(Array) var value

onready var node : Node


export(Dictionary) var Props = {
	"prop": [],
	"objOfProp": [],
	"method": "",
	"objOfMethod" : [],
	"value": []
}

#I dont think this will work

#func modify_proprties():
#	var p = get(ObjOfProp).get(Property)
#	call(Method, value)
#	p.call(method[i], value[i])
#	if Globals.gameState.get(prop[i]).get_class() != "Big":
#		p = float(p.toString())
#	Globals.gameState.set(prop[i], p)
