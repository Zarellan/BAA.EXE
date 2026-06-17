extends StaticBody2D
class_name PlatformWay


enum Type{
	normal,
	move,
	cloud
}

@export var visibleNotifier:VisibleOnScreenNotifier2D
@export var collision:CollisionShape2D
@export var partic:GPUParticles2D

var isHiding = false
var hiddenStatic = false

var scored = false

var jumpedOn = false

var player:PlayerPlatform
var defaultPosY = 0

var platformType:Type

var barrier1:CollisionShape2D
var barrier2:CollisionShape2D
func _ready() -> void:
	if (get_tree().current_scene.name == "Platform"): # STOP SENDING ME TO "Platform" SCENE
		get_tree().change_scene_to_file("res://Scenes/Minigames/PlaformMinigame.tscn")
	visibleNotifier.screen_exited.connect(func():
		hiddenStatic = true)
	visibleNotifier.screen_entered.connect(func():
		hiddenStatic = false)
	defaultPosY = position.y
	
	barrier1 = get_tree().get_first_node_in_group("Barrier1")
	barrier2 = get_tree().get_first_node_in_group("Barrier2")
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if (position.y >= get_tree().get_first_node_in_group("PlayerPlatform").position.y + 60):
		collision.disabled = false
	else:
		collision.disabled = true
	if (hiddenStatic && position.y >= get_tree().get_first_node_in_group("PlayerPlatform").position.y):
		HidePlatform()
	CountPoint()
	pass

func _physics_process(delta: float) -> void:
	Move(delta)

var direction = 1
var speed = 100

func Move(delta):
	if (platformType == Type.move):
		position.x += direction * speed * delta
	if (global_position.x  < (barrier1.global_position.x + (barrier1.shape.size.x*barrier1.global_scale.x))):
		direction = 1
	elif (global_position.x + ((collision.shape.size.x * collision.global_scale.x)/2.0)  > (barrier2.global_position.x - (barrier2.shape.size.x * barrier2.global_scale.x)/2)):
		direction = -1

var twPosY:Tween
func JumpedOn(velocityStrengthY: float):
	var standard_landing_velocity = 500.0
	
	var velocity_factor = absf(velocityStrengthY) / standard_landing_velocity
	
	var platfImpact = GameHandler.saveDataRebirth.platformImpact
	
	var base_sink = 4.0 * velocity_factor * platfImpact
	
	var randomY = base_sink * randf_range(0.9, 1.1)
	
	var min_sink = 0.3 * platfImpact
	var max_sink = 12.0 * platfImpact
	randomY = clampf(randomY, min_sink, max_sink)
	twPosY = TweenUtils.tweenY(self, defaultPosY + randomY, 0.3, TweenUtils.Ease.OutCirc)
	twPosY.finished.connect(func():
		twPosY = TweenUtils.tweenY(self, defaultPosY, 0.3, TweenUtils.Ease.InSine)
	)
	
	ParticleManager.PlayParticleOv(partic, randomY, self)
	return randomY
func CountPoint():
	if (!scored && position.y >= get_tree().get_first_node_in_group("PlayerPlatform").position.y + 60):
		PlatformMinigame.IncScore()
		PlatformMinigame.instance.CameraZoom()
		scored = true
func HidePlatform():
	if (isHiding):
		return
	TweenUtils.tweenAlpha(self,0,0.8,TweenUtils.Ease.linear).finished.connect(func():
		queue_free())
	isHiding = true
