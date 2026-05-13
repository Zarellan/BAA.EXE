extends Resource
class_name ShopList

@export var items:Array[ShopClass] = []

func AddItem(shopClass:ShopClass):
	items.append(shopClass)
