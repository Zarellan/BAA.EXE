extends Node

enum Quality{
	High,
	Low
}

@export var saveData:GameSaveData
@export var saveDataRebirth:GameSaveRebirth
@export var saveDataSettings:GameSaveSettings
@export var saveDataAchievements:GameSaveAchievements # will do later


var globalDelta:float

var timerSaveCooldown:Timer
var canSave = true
var dirtySave := false

var timerAutoCollector:Timer
var timerAutoCollectorSheep:Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (OS.has_feature("editor")):
		get_tree().reload_current_scene.call_deferred() # reloading early to face early crash rather that being surprised
	saveData = GameSaveData.new()
	saveDataRebirth = GameSaveRebirth.new()
	saveDataSettings = GameSaveSettings.new()
	saveDataAchievements = GameSaveAchievements.new()
	GameHandler.LoadAllDataGlob()
	timerSaveCooldown = CreateTimer(3, _on_save_timer_timeout)
	timerAutoCollector = CreateTimer(saveData.collectSpeed, NowCollect, false)
	timerAutoCollector.start()
	timerAutoCollectorSheep = CreateTimer(saveData.autoCollectSheep, CollectSheep, false)
	timerAutoCollectorSheep.start()
	timerAutoCollectorSheep.wait_time = AutoCollectSheepTotalParse()
	GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/lesiakower-morning-coffee-396750.mp3")
	pass # Replace with function body.

func CollectSheep():
	if (AutoCollectSheepActive() && is_instance_valid(get_sheep())):
		get_sheep().Pressed()
		timerAutoCollectorSheep.wait_time = AutoCollectSheepTotalParse()

func get_sheep():
	return get_tree().get_first_node_in_group("Sheep")
func _process(delta: float) -> void:
	globalDelta = delta

func CreateTimer(duration, delegate, oneshot = true) -> Timer:
	var tim = Timer.new()
	tim.autostart = false
	tim.one_shot = oneshot
	tim.wait_time = duration
	
	add_child(tim)
	tim.timeout.connect(delegate)
	return tim

func SaveAllData():
	ResourceUtil.SaveResource(saveData,"SaveData","saver")
	dirtySave = false

func SaveAllDataRebirth():
	ResourceUtil.SaveResource(saveDataRebirth,"SaveDataRebirth","saver")

func LoadAllData():
	var loader:GameSaveData
	loader = ResourceUtil.LoadResources("SaveData","saver") as GameSaveData
	if loader == null:
		return false
	saveData = loader
	return true

func LoadAllDataRebirth():
	var loader:GameSaveRebirth
	loader = ResourceUtil.LoadResources("SaveDataRebirth","saver") as GameSaveRebirth
	if loader == null:
		return false
	saveDataRebirth = loader
	return true

func SaveAllDataSettings():
	ResourceUtil.SaveResource(saveDataSettings,"SaveDataSettings","saver")

func LoadAllDataSettings():
	var loader:GameSaveSettings
	loader = ResourceUtil.LoadResources("SaveDataSettings","saver") as GameSaveSettings
	if loader == null:
		return false
	saveDataSettings = loader
	return true

func SaveAllAchievements():
	ResourceUtil.SaveResource(saveDataAchievements,"SaveDataAchievements","saver")

func LoadAllAchievements():
	var loader:GameSaveAchievements
	loader = ResourceUtil.LoadResources("SaveDataAchievements","saver") as GameSaveAchievements
	if loader == null:
		return false
	saveDataAchievements = loader
	return true
	
func SaveAllDataGlob():
	SaveAllData()
	SaveAllDataRebirth()
	SaveAllDataSettings()
	SaveAllAchievements()
func LoadAllDataGlob():
	LoadAllData()
	LoadAllDataRebirth()
	LoadAllDataSettings()
	LoadAllAchievements()

func AddMoney():
	if (IncrementTotal() < 0):
		return
	saveData.money += IncrementTotal()
	dirtySave = true
	if (canSave):
		SaveAllDataGlob()
		timerSaveCooldown.start()
		canSave = false

func AddMoneyForce(quant:int):
	if (quant < 0):
		return
	saveData.money += quant
	if (get_sheep() != null):
		get_sheep().MoneyCollectedText()
	dirtySave = true
	if (canSave):
		SaveAllDataGlob()
		timerSaveCooldown.start()
		canSave = false

func AddMoneyRare():
	if (IncrementTotal() < 0):
		return
	saveData.money += IncrementTotal() * GoldWoolMultiplierTotal()
	dirtySave = true
	if (canSave):
		SaveAllDataGlob()
		timerSaveCooldown.start()
		canSave = false
func AddMoneyRainbow():
	if (IncrementTotal() < 0):
		return
	saveData.money += IncrementTotal() * RainbowWoolMultiplierTotal()
	dirtySave = true
	if (canSave):
		SaveAllDataGlob()
		timerSaveCooldown.start()
		canSave = false

func _on_save_timer_timeout():
	if dirtySave:
		SaveAllDataGlob()
	canSave = true

func IncrementTotal() -> int:
	return saveData.increment * saveData.clickMultiply * saveDataRebirth.multiplier_reb * saveDataAchievements.multiplyMoneyAchievement

func NowCollect():
	if (saveData.autoCollect <= 0):
		return
	if (get_sheep() != null):
		get_sheep().MoneyCollectedText()
	saveData.money += saveData.autoCollect
	timerAutoCollector.wait_time = saveData.collectSpeed
	SaveAllDataGlob()

func GamePausedPartil() -> bool:
	return PauseScript.paused || RebirthMenu.isRebirthMenu || saveDataRebirth.autoCollectSheepAbility || SkinChanger.isSkinChanging
	
func AutoCollectSheepActive():
	return saveData.autoCollectSheepAbility

func AutoCollectSheepTotal():
	return saveData.autoCollectSheep + saveDataRebirth.autoCollectSheep
func AutoCollectSheepTotalParse():
	if (saveData.autoCollectSheep + saveDataRebirth.autoCollectSheep >= 0.15):
		return saveData.autoCollectSheep + saveDataRebirth.autoCollectSheep
	else:
		return 0.15

func GoldWoolMultiplierTotal():
	return 10 + saveDataRebirth.goldWoolMultiplier
	
func RainbowWoolMultiplierTotal():
	return saveDataRebirth.rainbowWoolMultiplier

func TotalJumpPower():
	return saveData.jumpPower + saveDataRebirth.powerJump

func TotalAirAcceleration():
	return saveData.airAcceleration + saveDataRebirth.airAcceleration

func KeysWhenExit(ignoreKey:Array[String]):
	var input:Array[String] = ["ui_cancel","Key_Q", "Key_A"]
	for i in range(input.size()):
		if (ignoreKey.has(input[i])):
			continue
		if (Input.is_action_just_pressed(input[i])):
			return true
	return false
	
