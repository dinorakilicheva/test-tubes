extends Node
class_name Game

#var TUBES := [
#	[0, 1, 2, 5],
#	[0, 5, 2, 1],
#	[0, 0, 0],
#	[5, 2, 5, 1]
#]
#const COLORS := 2
#var tubes: Array = []
var l: Level

var _operations_counter: int = 0 setget add_a_pour, get_pours
var _volume_counter: int = 0 setget add_a_pour_volume, get_pours_volume


func _init() -> void:
	l = Globals.get_level()
	

func add_a_pour(_addition: int = 0) -> void:
	_operations_counter += 1


func get_pours() -> int:
	return _operations_counter
	
	
func add_a_pour_volume(addition: int) -> void:
	if addition < 0 || addition > Globals.MAX_TUBE_VOLUME:
		print_debug("Invalid argument for adding pour volume")
		return
	_volume_counter += addition
	

func get_pours_volume() -> int:
	return _volume_counter


func pour(source: int, from_neck: bool, target: int) -> bool:
	var is_success: bool = false
	#print_debug(" -- %s -> %s --" % [source, target])
	#print_debug("Source: ", l.get_tube(source).get_content())
	#print_debug("Target before: ", l.get_tube(target).get_content())
	var pouring: Array = []
	if from_neck:
		pouring = l.get_tube(source).drain_a_portion()
	else:
		pouring = l.get_tube(source).drain_a_bottom_portion()
	var return_pouring: Array = pouring.duplicate()
	return_pouring = l.get_tube(target).add_a_portion(return_pouring)
	if (!pouring.empty() && return_pouring.empty()) || return_pouring.size() < pouring.size():
		add_a_pour()
		add_a_pour_volume(pouring.size() - return_pouring.size())
		is_success = true
	if from_neck:
		l.get_tube(source).restore_portion(return_pouring)
	else:
		l.get_tube(source).restore_bottom_portion(return_pouring)
	#print_debug("Source after: ", l.get_tube(source).get_content())
	#print_debug("Target after: ", l.get_tube(target).get_content())
	return is_success
		



