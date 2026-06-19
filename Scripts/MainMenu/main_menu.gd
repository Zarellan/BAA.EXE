extends Control

@export var bar:TextureProgressBar
@export var scenePath: String
@export var background: TextureRect

var progress : Array[float] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceLoader.load_threaded_request(scenePath)
	TweenUtils.tweenScalePingPong(background,Vector2(1,1),Vector2(1,1.05),2,TweenUtils.Ease.InOutSine)
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
			TransitionScript.ChangeScene2(scene)
	pass
