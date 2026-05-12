extends Node2D


@export var moneyText:Control
@export var textMoneyRev:Control
var isInside = false


var twe:Tween

var defaultScale

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	TweenUtils.tweenSkewPingPong(self,-0.04,0.04,1,TweenUtils.Ease.InOutSine)
	
	defaultScale = scale
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (isInside && Input.is_action_just_pressed("LeftMouse")):
		Pressed()
	pass

var scaleYtween:Tween
func Pressed():
	GameHandler.money += GameHandler.increment
	(moneyText as Money_counter).MoneyCollected()
	(textMoneyRev as TextMoneyRev).RevealMoney(GameHandler.increment)
	if (TweenUtils.isAlive(scaleYtween)):
		scaleYtween.stop()
	scale.y = defaultScale.y - 0.20
	scaleYtween = TweenUtils.tweenScaleY(self,defaultScale.y,0.3,TweenUtils.Ease.OutCirc)

func _on_static_body_2d_mouse_entered() -> void:
	isInside = true
	pass # Replace with function body.


func _on_static_body_2d_mouse_exited() -> void:
	isInside = false
	pass # Replace with function body.
