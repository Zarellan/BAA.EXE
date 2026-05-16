extends Node


@export var saveData:GameSaveData

var sheep:Sheep

var globalDelta:float

var timerSaveCooldown:Timer
var canSave = true
var dirtySave := false

var timerAutoCollector:Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	saveData = GameSaveData.new()
	GameHandler.LoadAllData()
	timerSaveCooldown = CreateTimer(3, _on_save_timer_timeout)
	timerAutoCollector = CreateTimer(saveData.collectSpeed, NowCollect, false)
	timerAutoCollector.start()
	
	sheep = get_tree().get_first_node_in_group("Sheep")
	
	GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/lesiakower-morning-coffee-396750.mp3")
	pass # Replace with function body.

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
	print("Save")
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
	if (saveData.increment < 0):
		return
	saveData.money += saveData.increment
	dirtySave = true
	if (canSave):
		SaveAllData()
		timerSaveCooldown.start()
		canSave = false

func _on_save_timer_timeout():
	if dirtySave:
		SaveAllData()
	canSave = true

func NowCollect():
	if (saveData.autoCollect <= 0):
		return
	sheep.MoneyCollectedText()
	saveData.money += saveData.autoCollect
	timerAutoCollector.wait_time = saveData.collectSpeed
	SaveAllData()
