extends Control

@export var bar:TextureProgressBar
@export var scenePath: String
@export var background: TextureRect
@export var sheep: Sprite2D
@export var tex: Control

var progress : Array[float] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/MainMenu.mp3")
	#ResourceLoader.load_threaded_request(scenePath)
	TweenUtils.tweenScalePingPong(background,Vector2(1,1.05),Vector2(1,1),2,TweenUtils.Ease.InOutSine)
	TweenUtils.tweenSkewPingPong(sheep,-0.04,0.04,1,TweenUtils.Ease.InOutSine)
	await get_tree().create_timer(1).timeout
	TweenUtils.tweenY(tex,-62.0,0.3,TweenUtils.Ease.OutCirc)
	await get_tree().create_timer(0.5).timeout
	ResourceLoader.load_threaded_request(scenePath)
	bar.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(scenePath, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var pct = progress[0] * 100
			bar.value = pct
		ResourceLoader.THREAD_LOAD_LOADED:
			bar.value = 100
			
			set_process(false)
			
			var scene = ResourceLoader.load_threaded_get(scenePath)
			TransitionScript.ChangeScene2(scene,func():
				GlobalSoundtrack.PlaySoundtrack("res://Soundtrack/lesiakower-morning-coffee-396750.mp3"))
	pass
