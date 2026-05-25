extends Node2D
class_name Sheep

@export var tutorial:Node2D
@export var tutorialTimer:Timer

@export var moneyText:Control
@export var textMoneyRev:Control
@export var part:GPUParticles2D
@export var partRare:GPUParticles2D
@export var mouseControl:ShearsEffect
@export var sheepShadow:Node2D
var isInside = false

var twe:Tween

var defaultScale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TweenUtils.tweenSkewPingPong(self,-0.04,0.04,1,TweenUtils.Ease.InOutSine)
	TweenUtils.tweenSkewPingPong(sheepShadow,deg_to_rad(18),deg_to_rad(29),1,TweenUtils.Ease.InOutSine)
	defaultScale = scale
	
	ReInitializeParticle(part)
	ReInitializeParticle(partRare)
	
	BringEidCap()
	
	if (!GameHandler.saveData.tutorialed):
		tutorialTimer.start()
		tutorialTimer.timeout.connect(StartTutorial)
	pass # Replace with function body.

var twTutorial:Tween
func StartTutorial():
	twTutorial = TweenUtils.tweenAlpha(tutorial,1,2,TweenUtils.Ease.linear)
func BringEidCap():
	if (GameHandler.saveData.checkCodes[0][1]):
		get_node("StaticBody2D/EidCap").visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (isInside && Input.is_action_just_pressed("LeftMouse")):
		Pressed()
	pass

func ReInitializeParticle(partic):
	partic.emitting = true
	partic.restart()
	partic.emitting = false

var scaleYtween:Tween
var canPress = true

func TweenTextMoney():
	if (TweenUtils.isAlive(scaleYtween)):
		scaleYtween.stop()
	scale.y = defaultScale.y - 0.20
	scaleYtween = TweenUtils.tweenScaleY(self,defaultScale.y,0.3,TweenUtils.Ease.OutCirc)

func MoneyCollectedText():
	(moneyText as MoneyCounter).MoneyCollected()

func Pressed():
	if canPress:
		if (randf_range(0.0,1.0) < GameHandler.saveData.rareChance):
			ParticleManager.PlayParticleOv(partRare,1)
			GameHandler.AddMoneyRare()
			GlobalAudio.PlayOneShot("res://Sounds/RareWool.mp3", 0,randf_range(0.99,1.01))
			(textMoneyRev as TextMoneyRev).RevealMoney(GameHandler.IncrementTotal() * 10,Color(0.944, 0.608, 0.037, 1.0))
		else:
			GameHandler.AddMoney()
			(textMoneyRev as TextMoneyRev).RevealMoney(GameHandler.IncrementTotal())
		MoneyCollectedText()
		ParticleManager.PlayParticleOv(part,3)
		GlobalAudio.PlayOneShot("res://Sounds/cut_sound.ogg", 12,randf_range(0.90,1.10))
		mouseControl.WoolCollected()
		#TweenTextMoney()
		if (TweenUtils.isAlive(scaleYtween)):
			scaleYtween.stop()
		scale.y = defaultScale.y - 0.20
		scaleYtween = TweenUtils.tweenScaleY(self,defaultScale.y,0.3,TweenUtils.Ease.OutCirc)
		if (!GameHandler.saveData.tutorialed):
			tutorialTimer.stop()
			TweenUtils.StopTween(twTutorial)
			TweenUtils.tweenAlpha(tutorial,0,0.3,TweenUtils.Ease.linear)
			GameHandler.saveData.tutorialed = true
		canPress = false
		await get_tree().create_timer(0.01).timeout
		canPress = true

func _on_static_body_2d_mouse_entered() -> void:
	isInside = true
	pass # Replace with function body.


func _on_static_body_2d_mouse_exited() -> void:
	isInside = false
	pass # Replace with function body.
	
	# MAX SCROLL TO DOWN
	#var sc = $"../Control/CanvasLayer/Shop/ScrollContainer"
	#var vbar = sc.get_v_scroll_bar()
	#var real_max = vbar.max_value - vbar.page
	#TweenUtils.tweenScrollY(sc,real_max,0.5,TweenUtils.Ease.OutCirc)
