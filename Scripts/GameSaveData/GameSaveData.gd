extends Resource
class_name GameSaveData

@export var money:int = 0
@export var increment:int = 2
@export var clickMultiply:int = 1
@export var autoCollect:int = 0
@export var collectSpeed:float = 3
@export var autoCollectSheepAbility:bool = false
@export var autoCollectSheep:float = 3
@export var rareChance:float = 0.00
@export var shopListData:ShopList
@export var tutorialed:bool = false


#rewards
@export var checkCodes:Array[Array] = [["eid mubarak",false]]
