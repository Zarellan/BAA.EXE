extends Control

@export var listInit:RebirthList
@export var rebirthPrefab:PackedScene
@export var verticalContainer:VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadSystem()
	for i in range(listInit.items.size()):
		var ls = listInit.items[i]
		var pref = InstantiateUtil.Instantiate(rebirthPrefab,verticalContainer)
		(pref as RebirthItem).set_item(ls)
	GameHandler.saveDataRebirth.rebirthListData = listInit
	pass # Replace with function body.

func loadSystem():
	GameHandler.LoadAllDataRebirth()
	if (GameHandler.saveDataRebirth.rebirthListData == null):
		if listInit != null:
			listInit = listInit.duplicate(true)
		return
	listInit = GameHandler.saveDataRebirth.rebirthListData.duplicate(true)
