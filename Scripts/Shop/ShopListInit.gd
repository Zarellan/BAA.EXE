extends Control

@export var listInit:ShopList
@export var shopPrefab:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadSystem()
	for i in range(listInit.items.size()):
		var ls = listInit.items[i]
		var pref = InstantiateUtil.Instantiate(shopPrefab,$ScrollContainer/VBoxContainer)
		(pref as ShopItem).set_item(ls)
	GameHandler.saveData.shopListData = listInit
	pass # Replace with function body.

func loadSystem():
	GameHandler.LoadAllData()
	if (GameHandler.saveData.shopListData == null):
		return
	listInit = GameHandler.saveData.shopListData
