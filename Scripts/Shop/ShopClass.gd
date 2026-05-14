extends Resource
class_name ShopClass

@export var title: String
@export_multiline var description: String
@export var price:int
@export var level:int
@export var power:ShopItem.Powers
@export var tax:float
@export var taxInc:float

func _init(titl := "", desc := "" , pric := 20, po = ShopItem.Powers.none,tx:int = 1,txInc:int = 0):
	title = titl
	description = desc
	price = pric
	level = 0
	power = po
	tax = tx
	taxInc = txInc
