extends Resource
class_name GameSaveData

@export var money:int = 0
@export var increment:int = 2
@export var autoCollect:int = 0
@export var collectSpeed:float = 3
@export var rareChance:float = 0.00
@export var shopListData:ShopList
#settings
@export var soundtrackVolume:float = 70
@export var audioVolume:float = 70
@export var quality:GameHandler.Quality = GameHandler.Quality.High
@export var fps:int = 60
@export var vSync:bool = true

#rewards
@export var checkCodes:Array[Array] = [["eid mubarak",false]]
