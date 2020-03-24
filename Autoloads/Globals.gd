extends Node

var props = {}
var mask_name_to_bit = {}

func set(name, value):
	props[name] = value
	
func get(name):
	if !props.has(name):
		return null
	return props[name]
	
func erase(name):
	props.erase(name)
