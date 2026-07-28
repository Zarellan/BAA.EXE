extends Control


@export var transitionMaterial:Control

var isChanging = false

var tweenTransition:Tween

func _ready() -> void:

	pass

func ReloadScene(complete = null, startSDK = true):
	if (isChanging): return
	isChanging = true
	WebsiteUtil.StopSDK()
	tweenTransition = TweenUtils.tweenCustom(self,0,1,1,TweenUtils.Ease.linear,func(val):
		transitionMaterial.material.set_shader_parameter("progress", val))
	if (typeof(complete) == TYPE_CALLABLE):
		tweenTransition.finished.connect(func():
			ReloadSceneFormat(complete, startSDK))
	else:
		tweenTransition.finished.connect(func():
			ReloadSceneFormat(func(): pass, startSDK))

func ChangeScene(sceneFile:String, complete = null, startSDK = true):
	if (isChanging): return
	isChanging = true
	WebsiteUtil.StopSDK()
	tweenTransition = TweenUtils.tweenCustom(self,0,1,1,TweenUtils.Ease.linear,func(val):
		transitionMaterial.material.set_shader_parameter("progress", val))
	if (typeof(complete) == TYPE_CALLABLE):
		tweenTransition.finished.connect(func():
			ChangeSceneFormat(sceneFile, complete, startSDK))
	else:
		tweenTransition.finished.connect(func():
			ChangeSceneFormat(sceneFile, func(): pass, startSDK))

func ChangeScene2(sceneFile:PackedScene, complete = null, startSDK = true):
	if (isChanging): return
	isChanging = true
	WebsiteUtil.StopSDK()
	tweenTransition = TweenUtils.tweenCustom(self,0,1,1,TweenUtils.Ease.linear,func(val):
		transitionMaterial.material.set_shader_parameter("progress", val))
	if (typeof(complete) == TYPE_CALLABLE):
		tweenTransition.finished.connect(func():
			ChangeSceneFormat2(sceneFile, complete, startSDK))
	else:
		tweenTransition.finished.connect(func():
			ChangeSceneFormat2(sceneFile, func(): pass, startSDK))

func ReloadSceneFormat(complete:Callable, startSDK = true):
	TweenUtils.StopTween(tweenTransition)
	get_tree().reload_current_scene()
	if (startSDK):
		WebsiteUtil.StartSDK()
	tweenTransition = TweenUtils.tweenCustom(self,1,0,1,TweenUtils.Ease.linear,func(val):
		transitionMaterial.material.set_shader_parameter("progress", val))
	if (complete.is_valid()):
		complete.call()
	tweenTransition.finished.connect(func():isChanging = false)

func ChangeSceneFormat(sceneFile:String, complete:Callable, startSDK = true):
	TweenUtils.StopTween(tweenTransition)
	get_tree().change_scene_to_file.call_deferred(sceneFile)
	if (startSDK):
		WebsiteUtil.StartSDK()
	tweenTransition = TweenUtils.tweenCustom(self,1,0,1,TweenUtils.Ease.linear,func(val):
		transitionMaterial.material.set_shader_parameter("progress", val))
	if (complete.is_valid()):
		complete.call()
	tweenTransition.finished.connect(func():isChanging = false)

func ChangeSceneFormat2(sceneFile:PackedScene, complete:Callable, startSDK = true):
	TweenUtils.StopTween(tweenTransition)
	get_tree().change_scene_to_packed.call_deferred(sceneFile)
	if (startSDK):
		WebsiteUtil.StartSDK()
	tweenTransition = TweenUtils.tweenCustom(self,1,0,1,TweenUtils.Ease.linear,func(val):
		transitionMaterial.material.set_shader_parameter("progress", val))
	if (complete.is_valid()):
		complete.call()
	tweenTransition.finished.connect(func():isChanging = false)

func _process(_delta: float) -> void:

	pass
