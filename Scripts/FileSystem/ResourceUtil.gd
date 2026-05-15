extends Node
class_name ResourceUtil

static var saveTo:String = "user://" # swap to user:// once finished
static var type = ".tres"

static func SaveResource(object, path:String, directory:String):
	var dir = DirAccess.open(saveTo+directory)
	if dir == null:
		DirAccess.make_dir_recursive_absolute(saveTo+directory)
	var fullPath = RemoveRootPath(path)
	ResourceSaver.save(object, saveTo + directory + "/" + fullPath + type)


static func LoadResources(path:String, directory:String):
	var fullPath = RemoveRootPath(path)
	if (!ResourceLoader.exists(saveTo + directory + "/" + fullPath + type)):
		push_warning("no path ",saveTo,directory,"/",fullPath," found")
		return
	return ResourceLoader.load(saveTo + directory + "/" + fullPath + type)

static func RemoveRootPath(path):
	var fullPath:String
	if (path.contains("res://")):
		fullPath = path.trim_prefix("res://")
	elif (path.contains("user://")):
		fullPath = path.trim_prefix("user://")
	else:
		fullPath = path
	return fullPath
