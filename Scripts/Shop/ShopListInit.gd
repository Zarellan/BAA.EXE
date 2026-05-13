extends Control

@export var listInit:ShopList
@export var shopPrefab:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(listInit.items.size()):
		var ls = listInit.items[i]
		var pref = InstantiateUtil.Instantiate(shopPrefab,$ScrollContainer/VBoxContainer)
		(pref as ShopItem).set_item(ls.title,ls.description,ls.price,ls.power)
	pass # Replace with function body.
