extends Control

@export var achievementPrefab:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(GameHandler.saveDataAchievements.skins.size()):
		var ls = GameHandler.saveDataAchievements.skins[i]
		if (ls.achievementName == "None"): #skip default one
			continue
		var pref = InstantiateUtil.Instantiate(achievementPrefab,$TextureRect/ScrollContainer/VBoxContainer)
		(pref as AchievementItem).SetAchieve(ls)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
