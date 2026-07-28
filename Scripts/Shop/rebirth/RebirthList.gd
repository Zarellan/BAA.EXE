extends Resource
class_name RebirthList


@export var items:Array[RebirthClass] = []

func AddItem(rebirthClass:RebirthClass):
	items.append(rebirthClass)
