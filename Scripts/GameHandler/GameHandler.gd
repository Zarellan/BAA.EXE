extends Node

enum Quality{
	High,
	Low
}

@export var saveData:GameSaveData


var globalDelta:float

var timerSaveCooldown:Timer
var canSave = true
var dirtySave := false

var timerAutoCollector:Timer
var timerAutoCollectorSheep:Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (OS.has_feature("editor")):
		get_tree().reload_current_scene() # reloading early to face early crash rather that being surprised
	saveData = GameSaveData.new()
	GameHandler.LoadAllData()
	timerSaveCooldown = CreateTimer(3, _on_save_timer_timeout)
	timerAutoCollector = CreateTimer(saveData.collectSpeed, NowCollect, false)
	timerAutoCollector.start()
	timerAutoCollectorSheep = CreateTimer(saveData.autoCollectSheep, CollectSheep, false)
	timerAutoCollectorSheep.start()
	GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/lesiakower-morning-coffee-396750.mp3")
	pass # Replace with function body.

func CollectSheep():
	if (saveData.autoCollectSheepAbility):
		get_sheep().Pressed()
		timerAutoCollectorSheep.wait_time = saveData.autoCollectSheep
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

func LoadAllData():
	var loader:GameSaveData
	loader = ResourceUtil.LoadResources("SaveData","saver") as GameSaveData
	if loader == null:
		return false
	saveData = loader
	return true

func AddMoney():
	if (IncrementTotal() < 0):
		return
	saveData.money += IncrementTotal()
	dirtySave = true
	if (canSave):
		SaveAllData()
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
		SaveAllData()
		timerSaveCooldown.start()
		canSave = false

func AddMoneyRare():
	if (IncrementTotal() < 0):
		return
	saveData.money += IncrementTotal() * 10
	dirtySave = true
	if (canSave):
		SaveAllData()
		timerSaveCooldown.start()
		canSave = false

func _on_save_timer_timeout():
	if dirtySave:
		SaveAllData()
	canSave = true

func IncrementTotal():
	return saveData.increment * saveData.clickMultiply

func NowCollect():
	if (saveData.autoCollect <= 0):
		return
	if (get_sheep() != null):
		get_sheep().MoneyCollectedText()
	saveData.money += saveData.autoCollect
	timerAutoCollector.wait_time = saveData.collectSpeed
	SaveAllData()
