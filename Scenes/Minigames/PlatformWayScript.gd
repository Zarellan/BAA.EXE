extends StaticBody2D
class_name PlatformWay

@export var visibleNotifier:VisibleOnScreenNotifier2D
@export var collision:CollisionShape2D
@export var partic:GPUParticles2D

var isHiding = false
var hiddenStatic = false

var scored = false

var jumpedOn = false

var player:PlayerPlatform
var defaultPosY = 0

func _ready() -> void:
	if (get_tree().current_scene.name == "Platform"): # STOP SENDING ME TO "Platform" SCENE
		get_tree().change_scene_to_file("res://Scenes/Minigames/PlaformMinigame.tscn")
	visibleNotifier.screen_exited.connect(func():
		hiddenStatic = true)
	visibleNotifier.screen_entered.connect(func():
		hiddenStatic = false)
	defaultPosY = position.y
	pass # Replace with function body.


func _process(delta: float) -> void:
	if (position.y >= get_tree().get_first_node_in_group("PlayerPlatform").position.y + 60):
		collision.disabled = false
	else:
		collision.disabled = true
	if (hiddenStatic && position.y >= get_tree().get_first_node_in_group("PlayerPlatform").position.y):
		HidePlatform()
	CountPoint()
	pass

var twPosY:Tween
func JumpedOn(velocityStrengthY:float): #I might change the calculation (buff or nerf who knows)
	var yStrength = velocityStrengthY * 0.01
	var randomY = randf_range(1,3) * yStrength
	randomY = clampf(randomY, 1,10)
	twPosY = TweenUtils.tweenY(self,defaultPosY + randomY,0.3,TweenUtils.Ease.OutCirc)
	twPosY.finished.connect(func():
		twPosY = TweenUtils.tweenY(self,defaultPosY,0.3,TweenUtils.Ease.InSine))
	ParticleManager.PlayParticleOv(partic,randomY,self)
	return randomY
func CountPoint():
	if (!scored && position.y >= get_tree().get_first_node_in_group("PlayerPlatform").position.y + 60):
		PlatformMinigame.IncScore()
		scored = true
func HidePlatform():
	if (isHiding):
		return
	TweenUtils.tweenAlpha(self,0,0.8,TweenUtils.Ease.linear).finished.connect(func():
		queue_free())
	isHiding = true
