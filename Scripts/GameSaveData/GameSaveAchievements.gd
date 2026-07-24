extends Resource
class_name GameSaveAchievements

@export var skins:Array[SkinItem]

@export var skinUsed:String = "def"
@export var canColorWool:bool = true

# player progress
@export var playerClicks = 0
#super powers
@export var multiplyMoneyAchievement:float = 1
@export var increaseJumpAchievement:float = 0

#minigames score
@export var platformMinigameScore:int = 0

#tips (in case the player is missing a detail)
@export var tips:Dictionary[String, bool] = {
	"minigame_1": false,
	"choose_wise": false,
	"minigame_2": false,
	"rebirth_1": false,
	"rebirth_2": false
}
