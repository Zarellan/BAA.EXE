extends Resource
class_name ShopClass

@export var title: String
@export var image:Texture2D
@export_multiline var description: String
@export var price:int
@export var level:int
@export var power:ShopItem.Powers
@export var tax:float
@export var taxInc:float
@export var canBuy := true

#I was testing a specific system for future uses
#@export var nod:String
#@export var fun:String
#@export var args: Array[Variant]

func _init(titl := "",img:Texture2D = null, desc := "" , pric := 20, po = ShopItem.Powers.none,tx:int = 1,txInc:int = 0):
	title = titl
	if (img == null):
		image = load("res://icon.svg")
	else:
		image = img
	description = desc
	price = pric
	level = 0
	power = po
	tax = tx
	taxInc = txInc
