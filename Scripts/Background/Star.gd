extends Node2D


var starNode:Node2D
var lightNode:Node2D

var intense:ValueSaver

var materialLight:ShaderMaterial

var gotShot:bool = false

var gravity:float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	intense = ValueSaver.new()
	starNode = get_node("Sprite2D")
	lightNode = get_node("FakeLight")
	scale = Vector2(randf_range(0.7,1.3),randf_range(0.7,1.3))
	rotation_degrees = randf_range(-10,10)
	if (GameHandler.saveDataSettings.quality == GameHandler.Quality.High):
		lightNode.visible = true
		lightNode.material = lightNode.material.duplicate()
		materialLight = lightNode.material
		TweenUtils.tweenColorRGBPingPong(starNode,Color(4,4,4),Color(0.7,0.7,0.7),randf_range(2,5),TweenUtils.Ease.InOutSine)
		TweenUtils.tweenNumberPingPong(self,intense,0.20,0.3,randf_range(3.0,12.0),TweenUtils.Ease.InOutSine)
	else:
		lightNode.visible = false
		lightNode.material = null
	pass # Replace with function body.

var posXmove:float = 0
func _process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()

	if (lightNode.material != null):
		materialLight.set_shader_parameter("radius", intense.number)
	if (starNode.get_rect().has_point(mouse_pos) && Input.is_action_just_pressed("LeftMouse") && (Sheep.holdSniper && Sheep.canShoot) && !gotShot):
		posXmove = randf_range(-10,10)
		gravity = -15
		StarSpawner.starsShooted += 1
		GlobalAudio.PlayOneShot("res://Sounds/RebirthBought.mp3", 0)
		if (StarSpawner.starsShooted >= 5):
			GameHandler.UnlockSkin("School sheep")
		gotShot = true
	if (gotShot):
		position.x += posXmove * 5 * delta
		gravity += delta * 40
		position.y += gravity
		rotate(posXmove * delta)
		if (position.y > 1500):
			queue_free()
	pass
