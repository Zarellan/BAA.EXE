extends Resource
class_name ShopClass

@export var title: String
@export var description: String
@export var price:int
@export var level:int
@export var power:ShopItem.Powers

func _init(titl := "", desc := "" , pric := 20, po = ShopItem.Powers.none):
	title = titl
	description = desc
	price = pric
	level = 0
	power = po
