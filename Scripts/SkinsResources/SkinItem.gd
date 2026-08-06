extends Resource
class_name SkinItem

@export var name = "Default"
@export var description = "Desc"
@export var effectDescription = "EffectDesc"

@export var achievementName = "ach name"
@export var achievementTask = "ach task"
@export var achievementImage:Texture = load("res://icon.svg")

@export var unlocked:bool = false
#@export var platformAvailable = WebsiteUtil.Platform.none // this function is bugged for export
@export_enum("None:0", "CrazyGames:1","Newgrounds:2")
var platformAvailable: int = 0
# newground
@export var achievementID:int = 0 
