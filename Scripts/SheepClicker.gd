extends Node2D
class_name Sheep

@export var moneyText:Control
@export var textMoneyRev:Control
@export var part:GPUParticles2D
var isInside = false


var twe:Tween

var defaultScale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TweenUtils.tweenSkewPingPong(self,-0.04,0.04,1,TweenUtils.Ease.InOutSine)
	defaultScale = scale
	#print(itemList.items[0].name)
	
	#DirAccess.make_dir_recursive_absolute("user://saver")
	#ResourceSaver.save(itemList,"user://saver/ShopList.tres")
	#var loader:ShopList = ResourceLoader.load("user://saver/ShopList.tres") as ShopList
	#var vc:Vector2 = loader.items[1].vect
	#print(vc)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (isInside && Input.is_action_just_pressed("LeftMouse")):
		Pressed()
	pass

var scaleYtween:Tween
var canPress = true

func TweenTextMoney():
	if (TweenUtils.isAlive(scaleYtween)):
		scaleYtween.stop()
	scale.y = defaultScale.y - 0.20
	scaleYtween = TweenUtils.tweenScaleY(self,defaultScale.y,0.3,TweenUtils.Ease.OutCirc)

func MoneyCollectedText():
	(moneyText as Money_counter).MoneyCollected()

func Pressed():
	if canPress:
		GameHandler.AddMoney()
		MoneyCollectedText()
		(textMoneyRev as TextMoneyRev).RevealMoney(GameHandler.saveData.increment)
		ParticleManager.PlayParticle(part,3)
		GlobalAudio.PlayOneShot("res://Sounds/cut_sound.ogg", 6,randf_range(0.90,1.10))
		#TweenTextMoney()
		if (TweenUtils.isAlive(scaleYtween)):
			scaleYtween.stop()
		scale.y = defaultScale.y - 0.20
		scaleYtween = TweenUtils.tweenScaleY(self,defaultScale.y,0.3,TweenUtils.Ease.OutCirc)

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
