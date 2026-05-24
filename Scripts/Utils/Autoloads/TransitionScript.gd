extends Control


@export var transitionMaterial:Control
var materialValue:ValueSaver

var isChanging = false

var tweenTransition:Tween

func _ready() -> void:
	materialValue = ValueSaver.new()

func ChangeScene(sceneFile:String):
	if (isChanging): return
	isChanging = true
	tweenTransition = TweenUtils.tweenNumber(self,materialValue,1,1,TweenUtils.Ease.linear)
	tweenTransition.finished.connect(func():
		ChangeSceneFormat(sceneFile))

func ChangeScene2(sceneFile:PackedScene):
	get_tree().paused = false
	await get_tree().process_frame
	get_tree().change_scene_to_packed.call_deferred(sceneFile)

func ChangeSceneFormat(sceneFile:String):
	TweenUtils.StopTween(tweenTransition)
	ResourceUtil.RemoveResources("SaveData","saver")
	GameHandler.saveData = GameSaveData.new()
	get_tree().change_scene_to_file.call_deferred(sceneFile)
	tweenTransition = TweenUtils.tweenNumber(self,materialValue,0,1,TweenUtils.Ease.linear)
	tweenTransition.finished.connect(func():isChanging = false)

func _process(_delta: float) -> void:
	if (isChanging):
		transitionMaterial.material.set_shader_parameter("progress", materialValue.number)
