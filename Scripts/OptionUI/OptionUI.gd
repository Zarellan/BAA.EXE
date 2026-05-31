extends Control
class_name OptionUI

@export var shopPanel:Control
@export var rebirthPanel:Control
@export var upScroll:Control
@export var downScroll:Control

@export var moneyText:Control
@export var rebirthText:Control

static var isShop = true;
static var isRebirth = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rebirthPanel.position.x = 2480
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("Key_E") && !GameHandler.GamePausedPartil()):
		_on_shopping_kart_pressed()
	pass

var tweenShopPanel:Tween
var tweenUpScroll:Tween
var tweenDownScroll:Tween

var tweenMoneyText:Tween
var tweenRebirthText:Tween

func _on_shopping_kart_pressed() -> void:
	if (isRebirth):
		TweenUtils.StopTween(tweenRebirthPanel)
		tweenRebirthPanel = TweenUtils.tweenX(rebirthPanel,2480.0,0.3,TweenUtils.Ease.OutCirc)
		isRebirth = false
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
	EnsureTextChange()
	pass # Replace with function body.

var tweenRebirthPanel:Tween


func _on_shopping_kart_rebirth_pressed() -> void:
	if (isShop):
		TweenUtils.StopTween(tweenShopPanel)
		tweenShopPanel = TweenUtils.tweenX(shopPanel,2480.0,0.3,TweenUtils.Ease.OutCirc)
		isShop = false
	if (!isRebirth):
		TweenUtils.StopTween(tweenRebirthPanel)
		tweenRebirthPanel = TweenUtils.tweenX(rebirthPanel,1240.0,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenUpScroll)
		tweenUpScroll = TweenUtils.tweenAlpha(upScroll,1,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenDownScroll)
		tweenDownScroll = TweenUtils.tweenAlpha(downScroll,1,0.3,TweenUtils.Ease.OutCirc)
		isRebirth = true
	else:
		TweenUtils.StopTween(tweenRebirthPanel)
		tweenRebirthPanel = TweenUtils.tweenX(rebirthPanel,2480.0,0.3,TweenUtils.Ease.InSine)
		TweenUtils.StopTween(tweenUpScroll)
		tweenUpScroll = TweenUtils.tweenAlpha(upScroll,0,0.3,TweenUtils.Ease.OutCirc)
		TweenUtils.StopTween(tweenDownScroll)
		tweenDownScroll = TweenUtils.tweenAlpha(downScroll,0,0.3,TweenUtils.Ease.OutCirc)
		isRebirth = false
	EnsureTextChange()
	pass # Replace with function body.

func EnsureTextChange():
	var rebirthAlphaVal = 0
	var moneyAlphaVal = 0
	if (isRebirth):
		rebirthAlphaVal = 1
		moneyAlphaVal = 0
	else:
		rebirthAlphaVal = 0
		moneyAlphaVal = 1
	TweenUtils.StopTween(tweenMoneyText)
	TweenUtils.StopTween(tweenRebirthText)
	TweenUtils.tweenAlpha(moneyText,moneyAlphaVal,0.3,TweenUtils.Ease.linear)
	TweenUtils.tweenAlpha(rebirthText,rebirthAlphaVal,0.3,TweenUtils.Ease.linear)
