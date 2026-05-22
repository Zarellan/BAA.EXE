extends Node2D


var starNode:Node2D
var lightNode:Node2D

var intense:ValueSaver
var textureScale:ValueSaver

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intense = ValueSaver.new()
	textureScale = ValueSaver.new()
	starNode = get_node("Sprite2D")
	lightNode = get_node("PointLight2D")
	scale = Vector2(randf_range(0.7,1.3),randf_range(0.7,1.3))
	rotation_degrees = randf_range(-10,10)
	if (GameHandler.saveData.quality == GameHandler.Quality.High):
		TweenUtils.tweenColorRGBPingPong(starNode,Color(4,4,4),Color(0.7,0.7,0.7),randf_range(2,5),TweenUtils.Ease.InOutSine)
		TweenUtils.tweenNumberPingPong(self,intense,1.0,4.0,5,TweenUtils.Ease.linear)
		TweenUtils.tweenNumberPingPong(self,intense,1.0,4.0,5,TweenUtils.Ease.linear)
	pass # Replace with function body.

func _process(delta: float) -> void:
	(lightNode as PointLight2D).energy = intense.number
	print(intense.number)
