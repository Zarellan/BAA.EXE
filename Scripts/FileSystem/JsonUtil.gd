extends Node
class_name JsonUtil
# NOT RECOMMENDED, USE GODOT RESOURCES INSTEAD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



static func save_json(object, path):
	var dir = DirAccess.open("user://json")
	if dir == null:
		DirAccess.make_dir_recursive_absolute("user://json")
	var filePath = "user://json/"+path + ".json"
	var file = FileAccess.open(filePath, FileAccess.ModeFlags.WRITE)
	if file == null:
		push_error("failed to save file on " + filePath)
		return
	var jsonData = JSON.stringify(object)
	
	if jsonData == null:
		push_error("failed to save A2J on " + filePath)
		return
	file.store_string(jsonData)

static func load_json(path):
	var filePath = "user://json/"+path + ".json"
	if !FileAccess.file_exists(filePath):
		push_error("no path found from " + filePath)
		return null
	var file = FileAccess.open(filePath, FileAccess.READ)
	
	if file == null:
		push_error("no didn't open from " + filePath)
		return null
	var text = file.get_as_text()
	var json_object = JSON.new()
	
	json_object.parse(text)
	#var jsonData = JSON.parse_string(text)
	if json_object == null:
		push_error("no data found from path " + filePath)
		return null
	
	return json_object.data

static func save_json_persistent(object, path):
	var dir = DirAccess.open("res://json")
	if dir == null:
		DirAccess.make_dir_recursive_absolute("res://json")
	var filePath = "res://json/"+path + ".json"
	var file = FileAccess.open(filePath, FileAccess.WRITE)
	if file == null:
		push_error("failed to save file on " + filePath)
		return
	
	var jsonData = JSON.stringify(object)
	
	file.store_string(jsonData)

static func load_json_persistent(path):
	var filePath = "res://json/"+path + ".json"
	if !FileAccess.file_exists(filePath):
		push_error("no path found from " + filePath)
		return null
	var file = FileAccess.open(filePath, FileAccess.READ)
	
	if file == null:
		push_error("no didn't open from " + filePath)
		return null
	var text = file.get_as_text()
	
	var jsonData = JSON.parse_string(text)
	
	if jsonData == null:
		push_error("no data found from path " + filePath)
		return null
	
	return jsonData
