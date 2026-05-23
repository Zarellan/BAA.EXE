extends Node2D


var starNode:Node2D
var lightNode:Node2D

var intense:ValueSaver

var materialLight:ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intense = ValueSaver.new()
	starNode = get_node("Sprite2D")
	lightNode = get_node("FakeLight")
	scale = Vector2(randf_range(0.7,1.3),randf_range(0.7,1.3))
	rotation_degrees = randf_range(-10,10)
	if (GameHandler.saveData.quality == GameHandler.Quality.High):
		lightNode.visible = true
		lightNode.material = lightNode.material.duplicate()
		materialLight = lightNode.material
		TweenUtils.tweenColorRGBPingPong(starNode,Color(4,4,4),Color(0.7,0.7,0.7),randf_range(2,5),TweenUtils.Ease.InOutSine)
		TweenUtils.tweenNumberPingPong(self,intense,0.20,0.3,randf_range(3.0,12.0),TweenUtils.Ease.InOutSine)
	else:
		lightNode.visible = false
		lightNode.material = null
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if (lightNode.material != null):
		materialLight.set_shader_parameter("radius", intense.number)
	pass
