extends Control
class_name OptionUI

@export var shopPanel:Control
@export var upScroll:Control
@export var downScroll:Control

static var isShop = true;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Key_E") && !PauseScript.paused):
		_on_shopping_kart_pressed()
	pass

var tweenShopPanel:Tween
var tweenUpScroll:Tween
var tweenDownScroll:Tween

func _on_shopping_kart_pressed() -> void:
	if (!isShop):
		TweenUtils.StopTween(tweenShopPanel)
		tweenShopPanel = TweenUtils.tweenX(shopPanel,1240.0,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenUpScroll)
		tweenUpScroll = TweenUtils.tweenAlpha(upScroll,1,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenDownScroll)
		tweenDownScroll = TweenUtils.tweenAlpha(downScroll,1,0.3,TweenUtils.Ease.OutCirc)
		isShop = true
	else:
		TweenUtils.StopTween(tweenShopPanel)
		tweenShopPanel = TweenUtils.tweenX(shopPanel,2480.0,0.3,TweenUtils.Ease.InSine)
		TweenUtils.StopTween(tweenUpScroll)
		tweenUpScroll = TweenUtils.tweenAlpha(upScroll,0,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenDownScroll)
		tweenDownScroll = TweenUtils.tweenAlpha(downScroll,0,0.3,TweenUtils.Ease.OutCirc)
		isShop = false
	pass # Replace with function body.
