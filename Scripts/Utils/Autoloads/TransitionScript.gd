extends Control


@export var transitionMaterial:Control

var isChanging = false

var tweenTransition:Tween

func _ready() -> void:

	pass
	

func ChangeScene(sceneFile:String, complete = null):
	if (isChanging): return
	isChanging = true
	tweenTransition = TweenUtils.tweenCustom(self,0,1,1,TweenUtils.Ease.linear,func(val):
		transitionMaterial.material.set_shader_parameter("progress", val))
	if (typeof(complete) == TYPE_CALLABLE):
		tweenTransition.finished.connect(func():
			ChangeSceneFormat(sceneFile, complete))
	else:
		tweenTransition.finished.connect(func():
			ChangeSceneFormat(sceneFile, func(): pass))

func ChangeScene2(sceneFile:PackedScene):
	get_tree().paused = false
	await get_tree().process_frame
	get_tree().change_scene_to_packed.call_deferred(sceneFile)

func ChangeSceneFormat(sceneFile:String, complete:Callable):
	TweenUtils.StopTween(tweenTransition)
	get_tree().change_scene_to_file.call_deferred(sceneFile)
	tweenTransition = TweenUtils.tweenCustom(self,1,0,1,TweenUtils.Ease.linear,func(val):
		transitionMaterial.material.set_shader_parameter("progress", val))
	if (complete.is_valid()):
		complete.call()
	tweenTransition.finished.connect(func():isChanging = false)

func _process(_delta: float) -> void:

	pass
