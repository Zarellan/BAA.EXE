extends Node2D
class_name Skins

@export var sheep:Sheep
@export var skins:Array[SkinItem]
@export var skinUses:Array[Node2D]

static var currentSkin = "Def"
var index:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (GameHandler.saveDataAchievements.skins == null || GameHandler.saveDataAchievements.skins.size() == 0):
		GameHandler.saveDataAchievements.skins = skins
		GameHandler.saveDataAchievements.skinUsed = GameHandler.saveDataAchievements.skins[0].name
	currentSkin = GameHandler.saveDataAchievements.skinUsed
	FindSkinIndex(currentSkin)
	LoadSkin()
	set_process(false)
	set_physics_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#if (Input.is_action_just_pressed("ui_right") && sheep.isSkin):
		#FindSkinIndex(GameHandler.saveDataAchievements.skinUsed)
		#ChooseSkin(1)
		#LoadSkin()
		#SuperPower()
	pass

func SetSkin(strn:String):
	FindSkinIndex(strn)
	LoadSkin()
	SuperPower()


func SuperPower():
	BringToDefault()
	match (GameHandler.saveDataAchievements.skinUsed):
		"Eid":GameHandler.saveDataAchievements.multiplyMoneyAchievement = 1.4
	
	
func LoadSkin():
	for i in range(skinUses.size()):
		if (currentSkin == skinUses[i].name):
			skinUses[i].visible = true
		else:
			skinUses[i].visible = false
	
	pass
#func ExceptionalSkins(name): # will do later for Font
	#match (name):
		#"Font":
			#
func SaveSkin():
	GameHandler.saveDataAchievements.skinUsed = currentSkin
func FindSkinIndex(nameStr:String):
	var skinsVar:Array[SkinItem] = GameHandler.saveDataAchievements.skins
	for i in range(skinsVar.size()):
		if (skinsVar[i].name == nameStr):
			index = i
			break
			pass
		pass

func ChooseSkin(indexer:int):
	index += indexer
	IndexRangeLimit(GameHandler.saveDataAchievements.skins)
	currentSkin = GameHandler.saveDataAchievements.skins[index].name
	LoadSkin()


func SetSkinMain():
	LoadSkin()
	SaveSkin()
	SuperPower()

func IndexRangeLimit(indexMax:Array):
	if (indexMax.size() - 1 < index):
		index = 0
	elif (index < 0):
		index = indexMax.size() - 1

func BringToDefault():
	GameHandler.saveDataAchievements.multiplyMoneyAchievement = 1.0
